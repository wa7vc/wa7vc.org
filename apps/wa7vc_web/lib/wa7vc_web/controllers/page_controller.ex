defmodule Wa7vcWeb.PageController do
  use Wa7vcWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # If no year given redirect to current year. This will need to change when we add the next year!
  def summergathering(conn, params) do
    case params["year"] do
      nil -> redirect conn, to: "/summergathering/2019"
      year ->
        try do
          render conn, "summergathering-#{year}.html"
        rescue
          Phoenix.Template.UndefinedError ->  conn
                                                |> put_flash(:error, "No Summer Gathering page for the year #{year} yet, sorry!")
                                                |> redirect(to: "/summergathering")
                                                |> halt()
        end
    end
  end
end
