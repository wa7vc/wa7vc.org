use Mix.Config

#####
# NOTE:
#   Both the IrcRobot, and Aprs modules assume there's only one dev active. Because it's just me.
#   If we have more devs working simultaneously, somehowe, we'll need to create unique names/command-codes
#   for each to prevent confusion.
#####

config :marvin, Marvin.IrcRobot,
  name: "WA7VC-DEV",
  full_name: "Marvin the WA7VC Robot, DEV MODE",
  aka: "&",
  password: ""

config :marvin, Marvin.Hooker,
  github_webhook_secret: "devsecret"

config :marvin, Marvin.Aprs,
  aprs_login: "WA7VC-WD"
