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

  # If no year given redirect to current year. This will need to change when we add the next year!
  def dmrgathering(conn, params) do
    case params["year"] do
      nil -> redirect conn, to: "/dmrgathering/2019"
      year ->
        try do
          render conn, "dmrgathering-#{year}.html"
        rescue
          Phoenix.Template.UndefinedError ->  conn
                                                |> put_flash(:error, "No DMR Gathering page for the year #{year} yet, sorry!")
                                                |> redirect(to: "/dmrgathering")
                                                |> halt()
        end
    end
  end

  def marvin(conn, params) do
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


    render conn, "marvin.html",
      wa7vc_web_version: vsn_wa7vc_web,
      wa7vc_version: vsn_wa7vc,
      marvin_version: vsn_marvin
  end
end
