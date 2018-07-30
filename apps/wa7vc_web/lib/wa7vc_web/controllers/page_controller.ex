defmodule Wa7vcWeb.PageController do
  use Wa7vcWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def nwaprssg(conn, _params) do
    render conn, "nwaprssg.html"
  end
end
