defmodule Marvin.USGSWaterservicesAPI.Value do
  @typedoc """
  Represents a single datetime/value pair. These values do not have any attached information about what they actually
  represent, which is why they have to be nested inside a Variable, which defines what the plain numeric value means.
  """

  alias Marvin.USGSWaterservicesAPI.Value

  defstruct datetime: nil,
            value: nil

  @type t :: %__MODULE__{
    datetime:  DateTime.t(),
    value: String.t()
  }

  @doc """
  Convert a single objects from the values list of the JSON result to a Value{} struct.

  Note that this is actually a single object from
  { value: { values: [ value: [ {ACTUAL_VALUE_OBJECT} ] ] } }
  because of the JSON layout returned by the API. Whoever designed that was a bit of a madman.
  """
  @spec from_value_object(Map.t()) :: Value.t()
  def from_value_object(val) do
    %Value{
      datetime: Timex.parse!(Map.fetch!(val, "dateTime"), "{ISO:Extended}"),
      value: Map.fetch!(val, "value")
    }
  end
end

defimpl String.Chars, for: Marvin.USGSWaterservicesAPI.Value do
  def to_string(val), do: "#{val.value}, #{Timex.format!(val.datetime, "on {Mshort}. {D} {YYYY}, at {h24}:{m} {Zabbr}")}"
end