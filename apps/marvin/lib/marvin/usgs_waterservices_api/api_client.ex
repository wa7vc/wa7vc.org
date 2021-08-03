defmodule Marvin.USGSWaterservicesAPI.APIClient do
  @behaviour Marvin.USGSWaterservicesAPI.APIClientBehaviour

  use Marvin.USGSWaterservicesAPI.Types
  alias Marvin.USGSWaterservicesAPI.Station
  require Logger

  @base_url "https://waterservices.usgs.gov/nwis/iv/"
  # GZip is requested by USGS, but not currently supported by HTTPoison/Hackney ["Accept-Encoding": "gzip,deflate"]
  @headers []
  @options [
    recv_timeout: 50_000 # Yes, a 50 second timeout. Their API can be **very** slow when generating a new result...
  ]

  def http_adapter, do: Application.get_env(:marvin, :usgs_waterservice_http_adapter)

  @doc """
  Returns a list of Station structs.
  In case of any error fetching or parsing the results: returns an empty list.
  """
  @spec fetch_sites([integer()], period) :: [Station.t()]
  def fetch_sites(site_ids, query_period) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: result_body}} <- http_adapter().get(build_url(site_ids, query_period), @headers, @options),
         {:ok, decoded_body} <- Jason.decode(result_body),
         {:ok, parsed_stations_list} <- parsed_json_to_stations_list(decoded_body)
    do
      parsed_stations_list
    else
      {:ok, %HTTPoison.Response{status_code: code}} ->
        Logger.error("HTTP Request to USGS Waterservices API returned non-200 response code: #{code}, no stations parsed.")
        []
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("HTTP Request to USGS Waterservices API returned errror: #{inspect(reason)}")
        []
      {:error, %Jason.DecodeError{} = err} ->
        Logger.error("Could not decode JSON returned by the USGS Waterservices API (#{Exception.message(err)}), no stations parsed.")
        []
      {:error, :wrong_json_structure} ->
        Logger.error("Response from USGS Waterservices API appears to be an incorrect JSON structure.")
        []
      _ ->
        Logger.error("Unknown error while handling return USGS Waterservices result")
        []
    end
  end

  @doc """
  Convenience function which calls fetch_sites() for the provided list of stations, requesting the last 2 hours of data
  for those sites.
  """
  @spec fetch_last_2_hours_for_sites([integer()]) :: [Station.t()]
  def fetch_last_2_hours_for_sites(site_ids) do
    fetch_sites(site_ids, :PT2H)
  end

  @doc """
  Convenience function to return a Station struct result for a single site ID
  """
  @spec fetch_site(integer(), period) :: Station.t()
  def fetch_site(site_id, query_period) do
    stations = fetch_sites([site_id], query_period)
    # TODO: error checking here to make sure we have valid stations, not an empty list
    List.first(stations)
  end

  @spec build_url([integer()], period) :: String.t()
  defp build_url(sites, query_period) do
    "#{@base_url}?format=json&period=#{query_period}&sites=" <> Enum.join(sites, ",")
  end

  # Makes a basic effort to check if we have what appears to be a correct JSON structure
  @spec parsed_json_to_stations_list(Map.t()) :: [Station.t()]
  defp parsed_json_to_stations_list(result_map) do
    if is_map(result_map) and result_map["value"]["timeSeries"] do
      {:ok,
        result_map["value"]["timeSeries"]
        |> Enum.reduce(%{}, fn timeseries_object, acc ->
          # TODO: Is it possible for sites to have the same name? The agencyCode:value format doesn't quite work because the fact that siteCode is a list is not documented, so I'm not sure what the API might actually return. Maybe take the first two components of the name? (Third component is unique per-variable)
          site_id = timeseries_object["sourceInfo"]["siteName"]
          Map.put(acc, site_id, [timeseries_object | Map.get(acc, site_id, [])])
        end)
        |> Map.values
        |> Enum.map(&Station.from_list_of_timeseries_objects/1)
      }
    else
      {:error, :wrong_json_structure}
    end
  end
end