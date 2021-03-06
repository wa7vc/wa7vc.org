defmodule Wa7vcWeb.Router do
  use Wa7vcWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {Wa7vcWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wa7vcWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/dmrgathering", PageController, :dmrgathering
    get "/dmrgathering/:year", PageController, :dmrgathering
    get "/summergathering", PageController, :summergathering
    get "/summergathering/:year", PageController, :summergathering
    get "/nwaprssg", PageController, :summergathering

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
end
