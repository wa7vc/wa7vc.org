# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wa7vc_web,
  namespace: Wa7vcWeb

# Configures the endpoint
config :wa7vc_web, Wa7vcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O1t5BciZwZ1fm5RNn1WJjkgCFuQOwI9hVKjGDOAdyIkfKTzaexMYLXrJpCb02Agh",
  render_errors: [view: Wa7vcWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Wa7vcWeb.PubSub

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :wa7vc_web, :generators,
  context_app: :wa7vc

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
