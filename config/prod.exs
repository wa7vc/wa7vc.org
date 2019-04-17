use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :sentry,
  dsn: "${SENTRY_DSN}",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

