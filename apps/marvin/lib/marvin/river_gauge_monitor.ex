defmodule Marvin.RiverGaugeMonitor do
  @doc """
  Get the last 2 hours of data for [USGS Instantaneous Values API](https://waterservices.usgs.gov/rest/IV-Service.html)
  for river gauging stations local to ValleyCamp, North Bend WA on a 5-minute interval.
  https://waterservices.usgs.gov/nwis/iv/?sites=12144500,12142000,12141300,12143400&format=json&period=PT2H

  Note that the API appears to return results ordered by the site ID, so at the moment we make no effort to to sort the
  returned stations before presenting them to the UI for display. However, this behavior doesn't seem to be documented
  on the API docs, so it's possible that it might change in the future and require us to sort the

  WaterML (translated to JSON by their API) documentation at http://his.cuahsi.org/documents/WaterML_1_1_part1_v2.pdf
  (The USGS also offers a [Daily Values web service](https://waterservices.usgs.gov/rest/DV-Service.html) which we haven't investigated yet.)
  """

  use GenServer
  alias Marvin.PrefrontalCortex, as: STM
  require Logger

  @update_interval 300_000 # 1000 * 60 * 5, Refresh data every 5 minutes
  @gauge_stations [12144500,12142000,12141300,12143400]

  def api_client, do: Application.get_env(:marvin, :usgs_waterservice_api_client)

  def get_latest do
    GenServer.call(__MODULE__, {:get_latest})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :fetch_usgs_data, 2_000)
    {:ok, %{latest: []}}
  end

  # Returns {:ok, result}, or {:error} if state doesn't have the latest data for some reason
  def handle_info(:fetch_usgs_data, state) do
    result = api_client().fetch_last_2_hours_for_sites(@gauge_stations)
    STM.increment(:usgs_river_data_fetches_count)
    STM.put(:usgs_river_data_latest_fetch_timestamp, DateTime.utc_now())
    STM.put(:usgs_river_data_latest, result)
    Process.send_after(self(), :fetch_usgs_data, @update_interval)
    {:noreply, Map.put(state, :latest, result)}
  end

  def handle_call({:get_latest}, _from, state) do
    {:reply, Map.fetch(state, :latest), state}
  end

end
