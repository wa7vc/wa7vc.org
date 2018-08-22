use Mix.Config

config :marvin, Marvin.Robot,
  name: "WA7VC-DEV",
  full_name: "Marvin the WA7VC Robot, DEV MODE",
  aka: "&",
  password: ""

config :marvin, Marvin.Hooker,
  github_webhook_secret: "devsecret"
