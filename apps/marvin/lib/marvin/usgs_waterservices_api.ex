defmodule Marvin.USGSWaterservicesAPI do
  alias Marvin.USGSWaterservicesAPI.APIClient

  def api_client, do: Application.get_env(:usgs_waterservice_api, :api_client)

  defdelegate fetch_sites(site_ids, query_period), to: APIClient
  defdelegate fetch_last_2_hours_for_sites(site_ids), to: APIClient
  defdelegate fetch_site(site_id, query_period), to: APIClient

end
