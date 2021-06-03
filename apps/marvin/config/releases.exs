import Config

config :marvin, Marvin.IrcRobot,
  password: System.fetch_env!("MARVIN_IRC_PASSWORD")

config :sentry,
  dsn: System.fetch_env!("MARVIN_SENTRY_DSN"),
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

config :logger,
  backends: [:console, Sentry.LoggerBackend]
