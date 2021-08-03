defmodule Marvin.USGSWaterservicesAPI.Station do
  @typedoc """
  Type that represents a specific USGS River Gauging station and result data it has produced.
  Data will be organized by a list of Variable structs.

  Note that if this object is created by the `APIClient.parsed_json_to_stations_list/1` method, the variables
  will be listed in reverse order to the JSON being parsed, due to list prepending.
  """

  defstruct site_code: nil,
            agency_code: nil,
            site_name: nil,
            latitude: nil,
            longitude: nil, 
            variables: [] 

  @type t :: %__MODULE__{
    site_code: String.t(),
    agency_code: String.t(),
    site_name: String.t(),
    latitude: String.t(),
    longitude: String.t(),
    variables: List.t()
  }

  alias Marvin.USGSWaterservicesAPI.{Station,Variable,Value}
  require Logger

  @doc """
  Return a string identifying the given station in "site_code - site_name" format.
  This is used when we need to show the correlation between the unique identifier and the human readable name, for
  example, in an IRC/text responder when asking which station the user is interested in.

  ## Examples
    iex> #{Station}.to_code_and_name_string(%#{Station}{site_code: 1234, site_name: "Test Site"})
    "1234 - Test Site"
  """
  @spec to_code_and_name_string(Station.t()) :: String.t()
  def to_code_and_name_string(station) do
    "#{station.site_code} - #{station.site_name}"
  end

  @doc """
  Another text-interfaced based helper, this returns a list of strings, the first of which is a station description,
  and the remaining are the `Varible.description_and_latest_value_string/1` for each variable of the station.

  ## Examples:
    iex> #{Station}.to_variables_and_values_lines(%#{Station}{site_name: "Test Site", latitude: "121.000", longitude: "42.000", variables: [%#{Variable}{description: "test var", values: [%#{Value}{value: "42.1"}]}]})
    ["The station Test Site, located at 121.000,42.000 reports the following data:", "test var: 42.1"]
  """
  @spec to_variables_and_values_lines(Station.t()) :: [String.t()]
  def to_variables_and_values_lines(station) do
    ["The station #{station.site_name}, located at #{station.latitude},#{station.longitude} reports the following data:"]
    |> Enum.concat(Enum.map(station.variables, &Variable.description_and_latest_value_string/1))
  end

  @doc """
  Convert a list of timeseries objects **that are assumed to be from the same station** into a single Station
  struct, containing a single copy of the Station data, and a list of the timeseries variables and values.

  Note that absolutely no effort is made to ensure that the list of timeSeries objects passed in are in fact for the
  same site. That responsibility is assumed to be on the calling function. The first timeSeries object passed in
  will be used to extract site description data, and the remaining timeSeries objects will be used solely to extract
  variables/values from.

  The API docs don't really explain how a site could have multiple sitecodes, but since none of the sites we're
  interested in seem to return that, we're going to use the first element of the sitecode list and hope for the best.
  Perhaps we should parse this to fetch the siteCode with the value we want? Or that is USGS/NWIS?
  """
  @spec from_list_of_timeseries_objects([Map.t()]) :: Station.t()
  def from_list_of_timeseries_objects(timeseries_objects)
    when is_list(timeseries_objects) and length(timeseries_objects) > 0 do
    s = hd(timeseries_objects)
    first_sitecode = hd(s["sourceInfo"]["siteCode"])
    %Station{
      site_code: first_sitecode["value"],
      agency_code: first_sitecode["agencyCode"],
      site_name: s["sourceInfo"]["siteName"],
      latitude: s["sourceInfo"]["geoLocation"]["geogLocation"]["latitude"],
      longitude: s["sourceInfo"]["geoLocation"]["geogLocation"]["longitude"],
      variables: Enum.map(timeseries_objects, &Variable.from_timeseries_object/1)
    }
  end
  def from_list_of_timeseries_objects(_ts_obj) do
    Logger.error("Could not parse a Station from an empty list, something has gone very wrong.")
    %Station{}
  end
end

defimpl String.Chars, for: Marvin.USGSWaterservicesAPI.Station do
  def to_string(sta), do: "#{sta.site_name}: #{Enum.join(sta.variables, " -- ")}"
end
