defmodule Wa7vcWeb.PageController do
  use Wa7vcWeb, :controller

  plug :sg_year when action in [:summergathering]
  plug :sg_meta_desc when action in [:summergathering]
  plug :dmr_year when action in [:dmrgathering]
  plug :dmr_meta_desc when action in [:dmrgathering]

  defp dmr_year(conn, _opts) do
    valid_years = ["2019", "2020"]
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
        |> put_flash(:error, "No DMR Gathering page for #{requested_year}, sorry!")
        |> assign(:load_year, latest_year)
    end
  end

  defp dmr_meta_desc(conn, _opts) do
    desc = case conn.assigns.load_year do
      "2020" -> "Cancelled due to Covid-19. Check back soon for 2021 dates and agenda."
      _ -> "The Pacific Northwest Digital Mobile Radio (WA7DMR) yearly gathering, the best event to find out the latest greatest information about DMR!"
    end
    conn
    |> assign(:meta_attrs, [ %{name: "description", content: desc} ])
  end

  defp sg_year(conn, _opts) do
    valid_years = ["2018", "2019", "2020"]
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
    render conn, "index.html", meta_attrs: meta_attrs_list
  end

  def dmrgathering(conn, _params) do
    render conn, "dmrgathering-#{conn.assigns[:load_year]}.html"
  end

  def summergathering(conn, _params) do
    render conn, "summergathering-#{conn.assigns[:load_year]}.html"
  end

  def marvin(conn, _params) do
    # Get application version numbers
    {:ok, vsn_wa7vc_web} = :application.get_key(:wa7vc_web, :vsn)
    List.to_string(vsn_wa7vc_web)
    {:ok, vsn_wa7vc} = :application.get_key(:wa7vc, :vsn)
    List.to_string(vsn_wa7vc)
    {:ok, vsn_marvin} = :application.get_key(:marvin, :vsn)
    List.to_string(vsn_marvin)


    # Calculate current iteration uptime
    ##Reference Snippet, although I'm keeping the somewhat more complicated method that's actually used below.
    ##wallclock_runtime = erlang.statistics(:wall_clock) |> elem(0) |> Kernel.div(1000)
    #{last_started_ago, last_called_ago} = :erlang.statistics(:wall_clock)
    #last_start_ts = NaiveDateTime.utc_now() |> NaiveDateTime.add(last_started_ago*-1, :millisecond)
    #last_start_lifespan = NaiveDateTime.diff(NaiveDateTime.utc_now(), last_start_ts)

    meta_attrs_list = [ %{name: "robots", content: "noindex"},
                        %{name: "description", content: "Statistics and interesting facts, with a healthy dose of depression."}
                      ]


    render conn, "marvin.html",
      wa7vc_web_version: vsn_wa7vc_web,
      wa7vc_version: vsn_wa7vc,
      marvin_version: vsn_marvin,
      meta_attrs: meta_attrs_list
  end


end
