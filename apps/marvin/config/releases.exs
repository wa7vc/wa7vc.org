import Config


config :marvin, Marvin.IrcRobot,
  password: System.fetch_env!("MARVIN_IRC_PASSWORD")
