defmodule Wa7vcWeb.PageController do
  use Wa7vcWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
