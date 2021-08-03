defmodule Marvin.USGSWaterservicesAPI.ValueTest do
  use ExUnit.Case, async: true
  import Marvin.USGSWaterservicesJsonHelper
  alias Marvin.USGSWaterservicesAPI.Value

  doctest Marvin.USGSWaterservicesAPI.Value

  test "correctly parses from a value JSON object" do
    {:ok, target_date} = DateTime.new(~D[2021-07-22], ~T[08:30:00], "America/Los_Angeles")
    parsed_val = Value.from_value_object(single_parsed_value_object())

    assert DateTime.compare(target_date, parsed_val.datetime) == :eq
    assert parsed_val.value == "98.5"
  end

  # Note that this date means we're intentionally testing:
  # - Day num in non-zero-prefixed format
  # - 24-hour time output.
  # - Correctly outputs when in daylight savings time.
  test "implements String.Chars to desired format" do
    {:ok, target_date} = DateTime.new(~D[2021-07-07], ~T[16:30:00], "America/Los_Angeles")
    v = %Value{datetime: target_date, value: "67.2"}

    assert "#{v}" == "67.2, on Jul. 7 2021, at 16:30 PDT"
  end
end
