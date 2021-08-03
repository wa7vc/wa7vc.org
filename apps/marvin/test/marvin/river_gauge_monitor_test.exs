defmodule Marvin.RiverGaugeMonitorTest do
  use ExUnit.Case
  alias Marvin.RiverGaugeMonitor
  alias Marvin.USGSWaterservicesAPI.{Station}

  doctest Marvin.RiverGaugeMonitor

  import Mox
  setup [:verify_on_exit!, :set_mox_global]
  setup do
    monitor = start_supervised!(Marvin.RiverGaugeMonitor)
    %{monitor: monitor}
  end

  @valid_single_result %{valid: true}

  # I hate this test, because of the sleep() to wait for the GenServer to call the function.
  # I hate it so very much. But for now, it'll do.
  test "get_latest/0 returns the results of the API fetch as a list", %{monitor: _monitor} do
    USGSWaterservicesAPIClientMock
    |> expect(:fetch_last_2_hours_for_sites, fn _sitecodes -> [%Station{site_name: "TEST SITE 1"}] end)

    assert RiverGaugeMonitor.get_latest() == {:ok, []}
    Process.sleep(2500) # Sleep just slightly longer than the expected delay before the genserver first calls the fetch
    assert {:ok, [
             %Station{site_name: "TEST SITE 1"}
           ]} == RiverGaugeMonitor.get_latest()
  end

end
