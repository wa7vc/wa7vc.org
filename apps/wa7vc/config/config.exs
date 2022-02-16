# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

import Config

# General application configuration
config :wa7vc,
  namespace: Wa7vc

# Configures the endpoint
config :wa7vc, Wa7vcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "devSecretKeyBaseMustBeAtLeast64BytesLong.ProductionUsesKeyFromAnsibleVault",
  render_errors: [view: Wa7vcWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Wa7vc.PubSub,
  live_view: [signing_salt: "devSecretLiveSigningSalt"],
  github_webhook_secret: "github_secret_dev"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :sentry,
  included_environments: [:prod],
  dsn: "${WA7VC_SENTRY_DSN}",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{
    env: "production"
  },
  release: "wa7vc@#{Mix.Project.config[:version]}"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :wa7vc, topologies: [
  local: [
    strategy: Cluster.Strategy.Epmd,
    config: [hosts: [:"wa7vc@127.0.0.1", :"marvin@127.0.0.1"]]
    ]
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
