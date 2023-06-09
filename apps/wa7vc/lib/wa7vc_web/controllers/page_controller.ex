defmodule Wa7vcWeb.PageController do
  use Wa7vcWeb, :controller

  plug :sg_year when action in [:summergathering]
  plug :sg_meta_desc when action in [:summergathering]

  defp sg_year(conn, _opts) do
    valid_years = ["2018", "2019", "2020", "2021", "2022", "2023"]
    latest_year = List.last(valid_years)
    requested_year = conn.path_params["year"]
    
    cond do
      requested_year == nil ->
        conn
        |> assign(:load_year, latest_year)
      requested_year in valid_years ->
        conn
        |> assign(:load_year, requested_year)
      true ->
        conn 
        |> put_flash(:error, "No Summer Gathering page for #{requested_year}, sorry!")
        |> assign(:load_year, latest_year)
    end
  end

  defp sg_meta_desc(conn, _opts) do
    desc = case conn.assigns.load_year do
      "2020" -> "2020 Summer Gathering cancelled due to Covid-19. Check back soon for 2021 Dates and Agenda!"
      _ -> "Our signature event, the Summer Gathering brings hams together for presentations, troubleshooting sessions, food, friends, and antennas!"
    end
    conn
    |> assign(:meta_attrs, [ %{name: "description", content: desc} ])
  end

  def index(conn, _params) do
    meta_attrs_list = [ %{name: "description", content: "Ham Radio in the Snoqualamie Middle Fork Valley. Find out more about us and our schedule of events."} ]
    conn = assign(conn, :meta_attrs, meta_attrs_list)
    render(conn, "index.html")
  end

  def summergathering(conn, _params) do
    render(conn, "summergathering-#{conn.assigns[:load_year]}.html")
  end

end
