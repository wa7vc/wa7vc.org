defmodule Marvin.USGSWaterservicesAPI.StationTest do
  use ExUnit.Case, async: true
  import Marvin.USGSWaterservicesJsonHelper
  alias Marvin.USGSWaterservicesAPI.{Station,Variable,Value}

  doctest Marvin.USGSWaterservicesAPI.Station

  # Tests parsing station details, and that the variables are order as we expect. (same order as the JSON)
  test "correctly parses from a list of timeseries JSON objects" do
    assert %Station{
      site_code: "12143400",
      agency_code: "USGS",
      site_name: "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
      latitude: 47.4151086,
      longitude: -121.5873213,
      variables: [
        %Variable{description: "Temperature, air, degrees Fahrenheit", latest_value_string: "61.0"},
        %Variable{description: "Precipitation, total, inches", latest_value_string: "0.00"}
      ]
    } = Station.from_list_of_timeseries_objects(list_of_parsed_timeseries_objects())
  end

  test "implements String.Chars to desired format" do
    {:ok, target_date} = DateTime.new(~D[2021-07-07], ~T[16:30:00], "America/Los_Angeles")
    s = %Station{
      site_name: "TEST STATION",
      variables: [
        %Variable{description: "Test Var 1", values: [%Value{datetime: target_date, value: "67.2"}]},
        %Variable{description: "Test Var 2", values: [%Value{datetime: target_date, value: "12"}]}
      ]
    }

    assert "#{s}" == "TEST STATION: Test Var 1: 67.2, on Jul. 7 2021, at 16:30 PDT -- Test Var 2: 12, on Jul. 7 2021, at 16:30 PDT"
  end
end
