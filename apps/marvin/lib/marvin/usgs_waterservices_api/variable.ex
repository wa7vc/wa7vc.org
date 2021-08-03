defmodule Marvin.USGSWaterservicesAPI.Variable do
  @typedoc """
  Type that represents a specific variable type, and a list of values representing data of that type.
  For example, a Station may return results for river height, cubit ft per second flow rate, and temperature.
  Each Variable will have a values list, containing {timestamp, value} tuples.
  """

  alias Marvin.USGSWaterservicesAPI.{Variable,Value}

  defstruct name: nil,
            description: nil,
            unit_code: nil,
            values: [],
            value_type: nil,
            no_data_value: nil,
            latest_value_string: nil

  @type t :: %__MODULE__{
    name: String.t(),
    description: String.t(),
    unit_code: String.t(),
    values: List.t(),
    value_type: String.t(),
    no_data_value: integer(),
    latest_value_string: String.t()
  }

  @doc """
  A variable has a list of values, but 99% of the time we're only interested in the latest value.
  This function provides a display-ready string containing the variable description, and the latest value.

  When cast to string will print the description and entire latest value, which includes the date/time taken.

  ## Examples
  Occasionally the USGS API returns an empty list of values if the station goes offline. Using this function to get the
  display string handles that case for the caller.
    iex> #{Variable}.latest_value_string(%#{Variable}{values: []})
    "(no values returned by USGS, station offline?)"

  The normal case is that we want the first element of the values array, which is sorted to be the most recent.
    iex> #{Variable}.latest_value_string(%#{Variable}{values: [%#{Value}{value: "29.3"}, %#{Value}{value: "0.00"}]})
    "29.3"

  Also provides a convenience function for building a string from a list of (sorted) values.
  This allows us to pre-load the latest value string onto the Variable during creation.
    iex> #{Variable}.latest_value_string([%#{Value}{value: "29.3"}, %#{Value}{value: "0.00"}])
    "29.3"
  """
  @spec latest_value_string([Value.t()]) :: String.t()
  def latest_value_string([%Value{} = first_val | _]) do
    "#{first_val.value}"
  end
  @spec latest_value_string(Variable.t()) :: String.t()
  def latest_value_string(%Variable{values: values}) when length(values) > 0 do
    "#{hd(values).value}"
  end
  @spec latest_value_string(term()) :: String.t()
  def latest_value_string(_anything_else) do
    "(no values returned by USGS, station offline?)"
  end

  @doc """
  Print a description of this variable, just the latest value, without any timestamp.
  """
  @spec description_and_latest_value_string(Variable.t()) :: String.t()
  def description_and_latest_value_string(%Variable{description: desc, values: [first_val | _]}) do
    "#{desc}: #{first_val.value}"
  end

  @doc """
  Take a single timeSeries object from the API's JSON response and convert it into a Variable struct.
  Note that this function entirely ignores site description data, and focuses only on the variable and it's values.

  Every timeseries JSON object has a "values" key, which is a list that appears to always have a single element, which
  in turn contains the singular "value" field, which is a list of the actual values. Who *wrote* this episode?!
  """
  @spec from_timeseries_object(Map.t()) :: Variable.t()
  def from_timeseries_object(timeseries_object) do
    sorted_values =
      hd(timeseries_object["values"])["value"]
      |> Enum.map(&Value.from_value_object/1)
      |> Enum.sort_by(&(&1.datetime), {:desc, DateTime})

    %Variable{
      name: timeseries_object["variable"]["variableName"],
      description: timeseries_object["variable"]["variableDescription"],
      unit_code: timeseries_object["variable"]["unit"]["unitCode"],
      values: sorted_values,
      value_type: timeseries_object["variable"]["valueType"],
      no_data_value: timeseries_object["variable"]["noDataValue"],
      latest_value_string: latest_value_string(sorted_values)
    }
  end
end

defimpl String.Chars, for: Marvin.USGSWaterservicesAPI.Variable do
  def to_string(var), do: "#{var.description}: #{hd(var.values)}"
end
