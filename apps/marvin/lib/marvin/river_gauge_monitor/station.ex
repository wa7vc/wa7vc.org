defmodule Marvin.RiverGaugeMonitor.Station do
  @typedoc """
    Type that represents a specific USGS River Gauging station and result data it has produced.
    Data will be organized by a list of Variable structs.
  """
  #@enforce_keys [:id, :name]

  defstruct siteCode: nil,
            siteName: nil,
            latitude: nil,
            longitude: nil, 
            variables: [] 

  @type t :: %__MODULE__{
    siteCode: String.t(),
    siteName: String.t(),
    latitude: String.t(),
    longitude: String.t(),
    variables: List.t()
  }

  def to_code_and_name_string(station) do
    "#{station.siteCode} - #{station.siteName}"
  end

  def to_variables_and_values_lines(station) do
    ["The station #{station.siteName}, located at #{station.latitude},#{station.longitude} reports the following data:"]
    |> Enum.concat(Enum.map(station.variables, &Marvin.RiverGaugeMonitor.Variable.to_value_string/1))
  end
end
