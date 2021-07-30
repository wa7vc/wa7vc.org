defmodule Marvin.RiverGaugeMonitor.Variable do
  @typedoc """
    Type that represents a specific variable type, and a list of values representing data of that type.
    For example, a Station may return results for river height, cubit ft per second flow rate, and temperature. 
    Each Variable will have a values list, containing {timestamp, value} tuples.
  """

  defstruct name: nil,
            description: nil,
            unitCode: nil,
            values: [],
            latest_value_string: nil

  @type t :: %__MODULE__{
    name: String.t(),
    description: String.t(),
    unitCode: String.t(),
    values: List.t(),
    latest_value_string: String.t()
  }

  def to_value_string(variable) do
    "#{variable.description}: #{variable.latest_value_string}"
  end
end
