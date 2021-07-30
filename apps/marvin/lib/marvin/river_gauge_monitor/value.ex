defmodule Marvin.RiverGaugeMonitor.Value do
  @typedoc """
    Represents a single datetime/value pair. We have no idea what this value represents, which is why values
    have to be nested insite Variable structs, which defines what the plain numeric value represents.
  """

  defstruct dateTime: nil,
            value: nil

  @type t :: %__MODULE__{
    dateTime:  DateTime.t(),
    value: String.t()
  }
end
