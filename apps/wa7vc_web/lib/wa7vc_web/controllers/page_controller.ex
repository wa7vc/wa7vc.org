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

  def marvin(conn, params) do
    {:ok, vsn_wa7vc_web} = :application.get_key(:wa7vc_web, :vsn)
    List.to_string(vsn_wa7vc_web)
    {:ok, vsn_wa7vc} = :application.get_key(:wa7vc, :vsn)
    List.to_string(vsn_wa7vc)
    {:ok, vsn_marvin} = :application.get_key(:marvin, :vsn)
    List.to_string(vsn_marvin)


    {:ok, born_ts, 0} = DateTime.from_iso8601("2018-08-01T00:00:00Z") #Close enough wall-clock time to when the website went live for the first time
    lifespan = DateTime.diff(DateTime.utc_now(), born_ts)

    {last_started_ago, last_called_ago} = :erlang.statistics(:wall_clock)
    last_start_ts = NaiveDateTime.utc_now() |> NaiveDateTime.add(last_started_ago*-1)
    last_start_lifespan = NaiveDateTime.diff(NaiveDateTime.utc_now(), last_start_ts)

    render conn, "marvin.html",
      wa7vc_web_version: vsn_wa7vc_web,
      wa7vc_version: vsn_wa7vc,
      marvin_version: vsn_marvin,
      lifespan: lifespan,
      last_start: last_start_ts,
      last_start_lifespan: last_start_lifespan
  end
end
