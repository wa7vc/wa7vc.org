use Mix.Config

config :marvin, Marvin.IrcRobot,
  password: "${MARVIN_IRC_PASSWORD}"

config :marvin, Marvin.Hooker,
  github_webhook_secret: "${GITHUB_WEBHOOK_SECRET}"
