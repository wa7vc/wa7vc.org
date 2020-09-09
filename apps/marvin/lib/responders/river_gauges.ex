defmodule Hedwig.Responders.RiverGauges do
  @moduledoc """
  Respond with data about local river gauging stations
  """

  use Hedwig.Responder
  alias Hedwig.Message
  alias Marvin.PubSub


  @usage """
  hedwig: rivers <station> - Report on information from local river gauges, using their USGS "siteCode" number.
  """
  respond ~r/rivers(\s*)$/i, msg do
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
    river_search("")
    |> Enum.each(fn(line) -> send msg, line end)
  end
  respond ~r/rivers (.+)/i, %Message{matches: %{1 => siteCode}} = msg do
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
    river_search(siteCode)
    |> Enum.each(fn(line) -> send msg, line end)
  end





  defp river_search(search_term) do
    search_term
    |> river_fetch_cached_data
    |> river_find_station
    |> river_build_response
  end

  defp river_fetch_cached_data(search_term) do
    {:ok, latest} = Marvin.RiverGaugeMonitor.get_latest()
    {search_term, latest}
  end

  defp river_find_station({search_term, cached_data}) when search_term == "", do: {:no_search_term, cached_data}
  defp river_find_station({_search_term, nil}), do: {:no_data}
  defp river_find_station({search_term, cached_data}) do
    {search_term, cached_data, Enum.find(cached_data, fn(station) -> station.siteCode == search_term end)}
  end

  defp river_build_response({:no_data}) do 
    ["No river data found, apparently I decided not to care..."]
  end
  defp river_build_response({:no_search_term, cached_data}) do
    ["Please specify which station using `rivers sitecode`:"]
    |> Enum.concat(river_map_data_to_stationlist_lines(cached_data))
  end
  defp river_build_response({search_term, cached_data, nil}) do 
    ["Station #{search_term} isn't one I'm tracking. Select from:"]
    |> Enum.concat(river_map_data_to_stationlist_lines(cached_data))
  end
  defp river_build_response({_search_term, _cached_data, station})  do
    Marvin.RiverGaugeMonitor.Station.to_variables_and_values_lines(station)
  end

  defp river_map_data_to_stationlist_lines(cached_data) do
    Enum.map(cached_data, &Marvin.RiverGaugeMonitor.Station.to_code_and_name_string/1)
  end
end
