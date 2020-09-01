# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

import Config

# General application configuration
config :wa7vc,
  namespace: Wa7vc

# Configures the endpoint
config :wa7vc, Wa7vcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O1t5BciZwZ1fm5RNn1WJjkgCFuQOwI9hVKjGDOAdyIkfKTzaexMYLXrJpCb02Agh",
  render_errors: [view: Wa7vcWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Wa7vc.PubSub,
  live_view: [signing_salt: "SECRET_SALT"],
  github_webhook_secret: "devsecret"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Since we only start marvin when we're in dev, we need to import Marvin's services config if we're in dev
if Mix.env() == :dev, do: import_config("../../marvin/config/services.exs")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
