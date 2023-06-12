defmodule Wa7vcWeb.Router do
  use Wa7vcWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_flash_from_params
    plug :put_root_layout, {Wa7vcWeb.Layouts, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wa7vcWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/dmrgathering", DMRGatheringController, :index
    get "/dmrgathering/:year", DMRGatheringController, :index

    get "/summergathering", SGController, :index
    get "/summergathering/:year", SGController, :index
    get "/nwaprssg", SGController, :index

    live "/marvin", MarvinLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wa7vcWeb do
  #   pipe_through :api
  # end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/phx-dashboard", metrics: Wa7vcWeb.Telemetry
    end
  end
  
  def put_flash_from_params(conn, _opts) do
    case conn.query_params["flash_error"] do
      "404" -> put_flash(conn, :error, "The page you were looking for could not be found")
      "500" -> put_flash(conn, :error, "Whoops, looks like that page had an error.")
      _ -> conn 
    end
  end
end
