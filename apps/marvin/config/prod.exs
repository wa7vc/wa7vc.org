import Config

config :marvin, Marvin.IrcRobot,
  password: "${MARVIN_IRC_PASSWORD}"

config :logger,
  backends: [:console, Sentry.LoggerBackend]
