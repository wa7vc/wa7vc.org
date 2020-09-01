defmodule Wa7vcWeb.WebhookController do
  use Wa7vcWeb, :controller

  # plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end

end
