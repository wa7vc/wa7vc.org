defmodule Marvin.USGSWaterservicesAPI.APIClientTest do
  use ExUnit.Case, async: true
  import Marvin.USGSWaterservicesJsonHelper
  alias Marvin.USGSWaterservicesAPI.APIClient
  alias Marvin.USGSWaterservicesAPI.{Station,Variable,Value}

  @moduletag capture_log: true

  import Mox
  setup :verify_on_exit!

  describe "fetch_sites/2 error handling" do
    test "returns an empty array HTTP Request return non-200 response" do
      HTTPMock
      |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Response{status_code: 500}} end)

      result = APIClient.fetch_sites([1234], :PT2H)
      assert result == []
    end

    test "returns an empty array if HTTPoison throws an error" do
      HTTPMock
      |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Error{reason: "Something exploded"}} end)

      result = APIClient.fetch_sites([1234], :PT2H)
      assert result == []
    end

    test "returns an empty array if malformed JSON is returned" do
      HTTPMock
      |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Response{status_code: 200, body: "<notJSON>Not actually JSON!</notJSON>"}} end)

      result = APIClient.fetch_sites([1234], :PT2H)
      assert result == []
    end

    test "returns an empty array if JSON body isn't correctly structured" do
      HTTPMock
      |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Response{status_code: 200, body: "{\"result\":{\"list\":[{\"item\":2}]}}"}} end)

      result = APIClient.fetch_sites([1234], :PT2H)
      assert result == []
    end
  end

  # Note that these tests are basic tests for the convenience methods. Sanity checking. Full parse test is later, and
  # in the tests for the submodules.
  describe "convenience fetch methods" do
    test "fetch_site/2 parses example JSON correctly, and returns only the first element of the list" do
      HTTPMock
      |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Response{status_code: 200, body: full_json_example()}} end)

      result = APIClient.fetch_site(1234, :PT2H)
      assert %Station{
               site_name: "MIDDLE FORK SNOQUALMIE RIVER NEAR TANNER, WA",
               latitude: 47.48593975,
               longitude: -121.6478809,
               variables: [
                 %Variable{
                   description: "Gage height, feet",
                   values: []
                 },
                 %Variable{
                   description: "Discharge, cubic feet per second",
                   values: []
                 }
               ]
           } = result
    end

    test "fetch_last_2_hours_for_sites/2 parses example JSON correctly" do
      HTTPMock
      |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Response{status_code: 200, body: full_json_example()}} end)

      result = APIClient.fetch_last_2_hours_for_sites([1234, 5678, 9101, 1121])
      assert [
               %Station{
                 site_name: "MIDDLE FORK SNOQUALMIE RIVER NEAR TANNER, WA",
                 latitude: 47.48593975,
                 longitude: -121.6478809,
                 variables: [
                   %Variable{
                     description: "Gage height, feet",
                     values: []
                   },
                   %Variable{
                     description: "Discharge, cubic feet per second",
                     values: []
                   },
                 ]
               },
               %Station{},
               %Station{
                 site_name: "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
                 variables: [
                   %Variable{
                     description: "Gage height, feet",
                     values: [
                       %Value{value: "10.65"},
                       %Value{},
                       %Value{},
                       %Value{},
                       %Value{},
                       %Value{},
                       %Value{},
                       %Value{value: "10.62"}
                     ]
                   },
                   %Variable{},
                   %Variable{},
                   %Variable{}
                 ]
               },
               %Station{}
             ] = result
    end
  end

  describe "fetch_sites/2 JSON result parsing" do
    test "correctly parses an entire example JSON example" do
      HTTPMock
     |> expect(:get, fn(_url, _headers, _opts) -> {:ok, %HTTPoison.Response{status_code: 200, body: full_json_example()}} end)

      result = APIClient.fetch_sites([1234, 5678], :PT2H)
      assert [%Station{} = station12141300, %Station{} = station12142000, %Station{} = station12143400, %Station{} = station12144500] = result

      assert %Station{
               site_name: "MIDDLE FORK SNOQUALMIE RIVER NEAR TANNER, WA",
               latitude: 47.48593975,
               longitude: -121.6478809,
               variables: [
                %Variable{
                  description: "Gage height, feet",
                  latest_value_string: "(no values returned by USGS, station offline?)",
                  name: "Gage height, ft",
                  no_data_value: -999999,
                  unit_code: "ft",
                  value_type: "Derived Value",
                  values: []
                },
                %Variable{
                  description: "Discharge, cubic feet per second",
                  latest_value_string: "(no values returned by USGS, station offline?)",
                  name: "Streamflow, ft&#179;/s",
                  no_data_value: -999999,
                  unit_code: "ft3/s",
                  value_type: "Derived Value",
                  values: []
                }
              ],
             } = station12141300

      assert %Station{
        site_name: "NF SNOQUALMIE RIVER NEAR SNOQUALMIE FALLS, WA",
        agency_code: "USGS",
        latitude: 47.61482536,
        longitude: -121.7134437,
        site_code: "12142000",
        variables: [
          %Variable{
            description: "Gage height, feet",
            latest_value_string: "2.11",
            name: "Gage height, ft",
            no_data_value: -999999,
            unit_code: "ft",
            value_type: "Derived Value",
            values: [
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 10, minute: 15, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 10, minute: 00, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 45, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 30, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 15, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 00, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 08, minute: 45, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 08, minute: 30, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "2.11" },
            ]
          },
          %Variable{
            description: "Discharge, cubic feet per second",
            latest_value_string: "98.5",
            name: "Streamflow, ft&#179;/s",
            no_data_value: -999999,
            unit_code: "ft3/s",
            value_type: "Derived Value",
            values: [
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 10, minute: 15, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 10, minute: 00, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 45, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 30, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 15, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 09, minute: 00, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 08, minute: 45, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"},
              %Value{datetime: %DateTime{year: 2021, month: 07, day: 22, hour: 08, minute: 30, second: 00, utc_offset: -25_200, std_offset: 0, zone_abbr: "-07", time_zone: "Etc/UTC-7"}, value: "98.5"}
            ]
          }
        ]
             } = station12142000

      # The remaining two we just want to sanity-check a bit, as opposed to the full struct assertions above
      assert %Station{
               site_name: "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
               variables: [
                 %Variable{description: "Gage height, feet", values: [%Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}]},
                 %Variable{description: "Discharge, cubic feet per second", values: [%Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}]},
                 %Variable{description: "Precipitation, total, inches", values: [%Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}]},
                 %Variable{description: "Temperature, air, degrees Fahrenheit", values: [%Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}, %Value{}]}
               ]
             } = station12143400

      assert %Station{
               site_name: "SNOQUALMIE RIVER NEAR SNOQUALMIE, WA",
               variables: [
                 %Variable{description: "Gage height, feet", unit_code: "ft", values: []},
                 %Variable{description: "Discharge, cubic feet per second", unit_code: "ft3/s", values: []}
               ]
             } = station12144500
    end
  end

end
