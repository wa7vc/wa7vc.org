import Config

# This config defines the configuration for services that we're connecting to.
# It is broken out into it's own config chain so that it can be imported by the
# Wa7vc app when Marvin is started as an OTP application. (Since it's config files
# have to be read manually in that case.)
#
config :marvin, Marvin.IrcRobot,
  adapter: Hedwig.Adapters.IRC,
  server: "chat.freenode.net",
  port: 6697,
  ssl?: true,
  name: "WA7VC",
  full_name: "Marvin the WA7VC Robot",
  aka: "!",
  rooms: [
    {"#wa7vc", ""},
  ],
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.Ping, []},
    {Hedwig.Responders.MarvinMisc, []},
  ]


config :marvin, Marvin.Aprs,
  server: 'noam.aprs2.net',
  port: 14580,
  filter: "r/47.4653992/-121.6803863/1",              # All packets within 1km radius of the compass point 2 at Valley Camp
  aprs_login: "WA7VC-W",                              # Arbitrarily pick "-W" for "web".
  aprs_passcode: "20725"                              # Yes, I know it's in source control. No it doesn't matter, anyone can generate it trivially.

import_config "services.#{Mix.env()}.exs"
