defmodule Wa7vcWeb.Router do
  use Wa7vcWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

    get "/marvin", PageController, :marvin
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wa7vcWeb do
  #   pipe_through :api
  # end
end
