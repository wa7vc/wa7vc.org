defmodule Marvin.USGSWaterservicesAPI.APIClientBehaviour do
  @moduledoc false

  use Marvin.USGSWaterservicesAPI.Types
  alias Marvin.USGSWaterservicesAPI.{Station}

  @callback fetch_sites([integer()], period()) :: [Station.t()]
  @callback fetch_last_2_hours_for_sites([integer()]) :: [Station.t()]
  @callback fetch_site(integer(), period()) :: Station.t()
end
