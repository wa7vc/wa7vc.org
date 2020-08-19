defmodule Marvin.RiverGaugeMonitor.Station do
  @typedoc """
    Type that represents a specific USGS River Gauging station and result data it has produced.
    Data will be organized by a list of Variable structs.
  """
  #@enforce_keys [:id, :name]

  defstruct siteCode: nil,
            siteName: nil,
            latitude: nil,
            longitude: nil, 
            variables: [] 

  @type t :: %__MODULE__{
    siteCode: String.t(),
    siteName: String.t(),
    latitude: String.t(),
    longitude: String.t(),
    variables: List.t()
  }

  def to_code_and_name_string(station) do
    "#{station.siteCode} - #{station.siteName}"
  end

  def to_variables_and_values_lines(station) do
    ["The station #{station.siteName}, located at #{station.latitude},#{station.longitude} reports the following data:"]
    |> Enum.concat(Enum.map(station.variables, &Marvin.RiverGaugeMonitor.Variable.to_value_string/1))
  end
end

defmodule Marvin.RiverGaugeMonitor.Variable do
  @typedoc """
    Type that represents a specific variable type, and a list of values representing data of that type.
    For example, a Station may return results for river height, cubit ft per second flow rate, and temperature. 
    Each Variable will have a values list, containing {timestamp, value} tuples.
  """

  defstruct name: nil,
            description: nil,
            unitCode: nil,
            values: [],
            latest_value_string: nil

  @type t :: %__MODULE__{
    name: String.t(),
    description: String.t(),
    unitCode: String.t(),
    values: List.t(),
    latest_value_string: String.t()
  }

  def to_value_string(variable) do
    "#{variable.description}: #{variable.latest_value_string}"
  end
end

defmodule Marvin.RiverGaugeMonitor.Value do
  @typedoc """
    Represents a single datetime/value pair. We have no idea what this value represents, which is why values
    have to be nested insite Variable structs, which defines what the plain numeric value represents.
  """

  defstruct dateTime: nil,
            value: nil

  @type t :: %__MODULE__{
    dateTime:  DateTime.t(),
    value: String.t()
  }
end


defmodule Marvin.RiverGaugeMonitor do
  @moduledoc """
  Monitor local (to ValleyCamp) USGS river gauging stations.

  ## Notes:
    - We rely on the fact that the API returns in the order that they exist in the query for ordering.
    - We rely on the fact that the API returns timestamps in oldest-to-newest order to fetch the "latest" value.

  ## History of tool
  The old EchoIRLP monitor scripts used the following URLS and gauging stations
  DATA_URL="http://waterdata.usgs.gov/wa/nwis/uv?cb_all_00060_00065=on&cb_00060=on&cb_00065=on&format=rdb&period=1&site_no=$1"
  SITE_URL="http://waterdata.usgs.gov/nwis/inventory?search_site_no=$1&format=sitefile_output&sitefile_output_format=rdb&column_name=station_nm"
  custom/custom.crons:*/15 * * * * (/home/irlp/custom/getGuage 12144500 &> /dev/null 2>&1)
  custom/custom.crons:*/15 * * * * (/home/irlp/custom/getGuage 12142000 &> /dev/null 2>&1)
  custom/custom.crons:*/15 * * * * (/home/irlp/custom/getGuage 12141300 &> /dev/null 2>&1)
  custom/custom.crons:*/15 * * * * (/home/irlp/custom/getGuage 12143400 &> /dev/null 2>&1)

  USGS has a new [Instantaneous Values API](https://waterservices.usgs.gov/rest/IV-Service.html), which can return XML/JSON results.
  Get the last 2 hours of data for a single site in JSON.
  https://waterservices.usgs.gov/nwis/iv/?site=12144500&format=json&period=PT2H
  Get 2 hours of data for all sites we previously accessed:
  https://waterservices.usgs.gov/nwis/iv/?sites=12144500,12142000,12141300,12143400&format=json&period=PT2H

  WaterML (translated to JSON by those queries) documentation at http://his.cuahsi.org/documents/WaterML_1_1_part1_v2.pdf
  (The USGS also offers a [Daily Values web service](https://waterservices.usgs.gov/rest/DV-Service.html) which we haven't investigated yet.)

  ## Parsing the Instantaneous Values
  The thought process for parsing the result is as follows:
    - Retrieve the value{} from the JSON result body
    - From that: Retrieve the timeSeries[] list
    - Each element of timeSeries[] will be an un-named {} (object). Each one represents a combination of station and variable. For example if your query
      is for a single station you'll have two objects. One for the gauge height in feet at that station, and one for the ft^3/s at that station.
      We **could** dynamically handle this and allow automatic parsing if they API started returning a new type of variable, etc, but these values have
      been static for at least a decade, and the USGS changes their api's very slowly. So we're going to make some assumptions about the data that is
      returned and yank out specifically what we're looking for. 
    - Walk the elements of the timeSeries[] list, extracting the necessary data into a results map containing only the values we care about.
    - Transform the results to group all the same gauging stations together so that we can easily find results per-station

  """

  use GenServer
  alias Marvin.PrefrontalCortex, as: STM
  require Logger

  @update_interval 300_000 # 1000 * 60 * 5, Refresh data every 5 minutes
  @gauge_stations [12144500,12142000,12141300,12143400]

  def get_latest do
    GenServer.call(__MODULE__, {:get_latest})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :fetch_usgs_data, 2_000)
    {:ok, %{}}
  end

  # Returns {:ok, result}, or {:error} if state doesn't have the latest data for some reason
  def handle_info(:fetch_usgs_data, state) do
    result = fetch_results()
    STM.increment(:usgs_river_data_fetches_count)
    STM.put(:usgs_river_data_latest_fetch_timestamp, DateTime.utc_now())
    STM.put(:usgs_river_data_latest, result)
    Process.send_after(self(), :fetch_usgs_data, @update_interval)
    {:noreply, Map.put(state, :latest, result)}
  end

  def handle_call({:get_latest}, _from, state) do
    {:reply, Map.fetch(state, :latest), state}
  end


  # Do the entire process of fetching the results and returning them as a list of Marvin.RiverGaugeMonitor.Station structs
  defp fetch_results do
    headers = [] # GZip requested by USGS, but not currently supported by HTTPoison/Hackney ["Accept-Encoding": "gzip,deflate"]
    options = [recv_timeout: 50_000] # Yes, a 50 second timeout. Their API can be **very** slow when generating a new result...
    
    case HTTPoison.get("https://waterservices.usgs.gov/nwis/iv/?sites=" <> Enum.join(@gauge_stations, ",") <> "&format=json&period=PT2H", headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
        |> extract_and_parse_timeseries()
        |> Enum.group_by(fn(x) -> x.siteCode end )
        |> grouped_timeseries_to_structs()
        |> Enum.reverse()
      {:ok, response} ->
        Logger.error("HTTP Request to get river gauge data returned non-200 response code: #{response.status_code}")
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTP Request to get river gauge data returned errror: #{inspect(reason)}")
    end
  end

  # Extracts the "timeseries" list from the USSGS JSON result, and parses it into an arbitrary map containing only the data we want, but following the same
  # structure as the timeseries json. (I.E. one result for each station/variable combination.
  # The results are in the following structure:
  #  %{
  #    "siteCode": "station_id",
  #    "siteName: "STATION LOCATION NAME",
  #    "variableDescription": "Text description of variable",
  #    "variableName": "Gage Height, ft",
  #    "variableUnitCode": "ft",
  #    "values": [
  #      ...,
  #      Marvin.RiverGaugeMonitor.Value
  #      ...,
  #    ]
  #  }
  # Each type of variable for each station will return a complete object, so we will need to group/reduce them to get to station HAS MANY variables HAS MANY values
  defp extract_and_parse_timeseries(fetched_json) do
    Map.fetch!(fetched_json, "value")
    |> Map.fetch!("timeSeries")
    |> Enum.reduce([], fn ts_obj, res_arr ->
      parsed_object = Enum.reduce(ts_obj, %{}, fn ts_kv, acc ->
        case ts_kv do
          {"sourceInfo", v} -> 
            acc
            |> Map.merge( %{:siteName => Map.fetch!(v, "siteName") })
            |> Map.merge( %{:siteCode => v |> Map.fetch!("siteCode") |> Enum.fetch!(0) |> Map.fetch!("value") })
            |> Map.merge( %{:latitude => Kernel.get_in(v, ["geoLocation", "geogLocation", "latitude"]) }) #v |> Map.fetch!("geoLocation") |> Map.fetch!("geogLocation") |> Map.fetch!("latitude") })
            |> Map.merge( %{:longitude => Kernel.get_in(v, ["geoLocation", "geogLocation", "longitude"]) }) #v |> Map.fetch!("geoLocation") |> Map.fetch!("geogLocation") |> Map.fetch!("longitude") })
          {"variable", v} ->
            acc
            |> Map.merge( %{:name => Kernel.get_in(v, ["variableName"]) })
            |> Map.merge( %{:description => Kernel.get_in(v, ["variableDescription"]) })
            |> Map.merge( %{:unitCode => Kernel.get_in(v, ["unit", "unitCode"]) })
          {"values", v} ->
            acc
            |> Map.put(:values, v |> Enum.fetch!(0) |> Map.fetch!("value") |> Enum.map(fn(r) -> %Marvin.RiverGaugeMonitor.Value{dateTime: Timex.parse!(Map.fetch!(r, "dateTime"), "{ISO:Extended}"), value: Map.fetch!(r, "value")} end) )
          _ -> acc
        end
      end)
      [ parsed_object | res_arr ]
    end)
  end

  # We're going to take the parsed timeseries result and convert it to a list of Station structs, each containing
  # a list of Variable structs, each containing a list of Value structs.
  # First we group_by to get a map %{"SITE_CODE_STRING" => [ LIST_OF_VARIABLES_FOR_SITE ]
  # Then, because they're grouped, we assume that other site description fields for the first variable in the list
  # is accurate for the station and extract them.
  # Lastly, it's a simple matter of mapping the Variables into structs.
  defp grouped_timeseries_to_structs(grouped_timeseries) do
    Enum.reduce(grouped_timeseries, [], fn {siteCode, station_vars}, acc ->
      first = List.first(station_vars)
      s = %Marvin.RiverGaugeMonitor.Station{siteCode: siteCode, 
        siteName: first[:siteName],
        latitude: first[:latitude],
        longitude: first[:longitude],
        variables: Enum.map(station_vars, &build_variable/1)
      }
      [ s | acc ]
    end)
  end

  defp build_variable(var_obj) do
    Kernel.struct(Marvin.RiverGaugeMonitor.Variable, var_obj)
    |> Map.put(:latest_value_string, "#{Map.fetch!(var_obj, :values) |> List.last() |> Map.fetch!(:value)}")
  end

end
