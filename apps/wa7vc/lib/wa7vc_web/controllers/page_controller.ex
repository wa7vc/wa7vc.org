defmodule Wa7vcWeb.PageController do
  use Wa7vcWeb, :controller

  def index(conn, _params) do
    meta_attrs_list = [ %{name: "description", content: "Ham Radio in the Snoqualamie Middle Fork Valley. Find out more about us and our schedule of events."} ]
    conn = assign(conn, :meta_attrs, meta_attrs_list)
    render(conn, "index.html")
  end

end
