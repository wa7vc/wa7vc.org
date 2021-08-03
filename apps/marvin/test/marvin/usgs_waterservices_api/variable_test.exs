defmodule Marvin.USGSWaterservicesAPI.VariableTest do
  use ExUnit.Case, async: true
  import Marvin.USGSWaterservicesJsonHelper
  alias Marvin.USGSWaterservicesAPI.{Variable, Value}

  doctest Marvin.USGSWaterservicesAPI.Variable

  test "correctly parses from a timeseries JSON object" do
    assert %Variable {
             name: "Gage height, ft",
             description: "Gage height, feet",
             unit_code: "ft",
             values: [
               %Value{value: "2.12"},
               %Value{},
               %Value{},
               %Value{},
               %Value{},
               %Value{},
               %Value{},
               %Value{value: "2.10"},
             ],
             value_type: "Derived Value",
             no_data_value: -999999,
             latest_value_string: "2.12"
           } = Variable.from_timeseries_object(single_parsed_timeseries_object())
  end

  test "correctly parses from a timeseries JSON object with no values" do
    assert %Variable {
      name: "Streamflow, ft&#179;/s",
      description: "Discharge, cubic feet per second",
      unit_code: "ft3/s",
      values: [],
      value_type: "Derived Value",
      no_data_value: -999999,
      latest_value_string: "(no values returned by USGS, station offline?)"
    } = Variable.from_timeseries_object(single_parsed_timeseries_object_with_no_values())
  end

  # Tests that:
  # - Shows description and most recent value
  # - Shows only most recent value, due to implied sorting of values as most-recent first
  test "implements String.Chars to the desired format" do
    {:ok, dt1} = DateTime.new(~D[2021-07-07], ~T[16:30:00], "America/Los_Angeles")
    {:ok, dt2} = DateTime.new(~D[2021-07-07], ~T[16:15:00], "America/Los_Angeles")
    v = %Variable{
      description: "Gage height, feet",
      values: [
        %Value{value: "67.2", datetime: dt1},
        %Value{value: "67.3", datetime: dt2},
      ]
    }

    assert "#{v}" == "Gage height, feet: 67.2, on Jul. 7 2021, at 16:30 PDT"
  end
end
