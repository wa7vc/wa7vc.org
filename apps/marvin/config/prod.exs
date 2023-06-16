import Config

# Do not print debug messages in production
# Also enable the Sentry backend for capturing logger data
config :logger,
  level: :info,
  backends: [:console, Sentry.LoggerBackend]

# Include Sentry.io configuration specific to production, but not dependent on
# runtime variables
config :sentry,
    environment_name: :prod,
    tags: %{
      env: "production"
    },
    release: "marvin@#{Application.spec(:marvin, :vsn)}"

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
