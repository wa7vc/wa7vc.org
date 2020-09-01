defmodule Wa7vcWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :wa7vc

  @session_options [
    store: :cookie,
    key: "_wa7vc_web_key",
    signing_salt: "QczfYGF+"  # TODO: Not that we're using it right now anyway, but this needs to get moved to ENV
  ]

  socket "/socket", Wa7vcWeb.UserSocket,
    websocket: true,
    longpoll: [check_origin: ["//wa7vc.org","//www.wa7vc.org"]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :wa7vc, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  #require Marvin.GithubWebhookPlug
  plug Wa7vcWeb.GithubWebhookPlug,
    mount: "/webhooks/github",
    secret: Application.get_env(:wa7vc, Wa7vcWeb.Endpoint)[:github_webhook_secret]

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options

  plug Wa7vcWeb.Router

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
