defmodule Marvin.USGSWaterservicesAPI.Types do
  defmacro __using__(_opts) do
    quote do
      # Technically types can conform to the ISO_8601 spec, but we're only going to support a couple of them here
      @type period :: :PT2H | :P7D
    end
  end
end