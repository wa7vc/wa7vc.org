import Config

config :marvin, topologies: [
  local: [
    strategy: Cluster.Strategy.Epmd,
    config: [hosts: [:"wa7vc@127.0.0.1", :"marvin@127.0.0.1"]]
    ]
]


config :marvin, Marvin.IrcRobot,
  adapter: Hedwig.Adapters.IRC,
  server: "irc.libera.chat",
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
    {Marvin.Responders.MarvinMisc, []},
    {Marvin.Responders.System, []},
    {Marvin.Responders.RiverGauges, []},
  ]


config :marvin, Marvin.Aprs,
  server: 'noam.aprs2.net',
  port: 14580,
  filter: "r/47.4653992/-121.6803863/1",              # All packets within 1km radius of the compass point 2 at Valley Camp
  aprs_login: "WA7VC-W",                              # Arbitrarily pick "-W" for "web".
  aprs_passcode: "20725"                              # Yes, I know it's in source control. No it doesn't matter, anyone can generate it trivially.

config :sentry,
  included_environments: [:prod],
  dsn: "${MARVIN_SENTRY_DSN}",
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  release: "marvin@#{Mix.Project.config[:version]}"


config :marvin,
  environment: Mix.env(),
  pubsub: [start: true],
  usgs_waterservice_http_adapter: Marvin.USGSWaterservicesAPI.HTTPAdapter,
  usgs_waterservice_api_client: Marvin.USGSWaterservicesAPI.APIClient

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :marvin, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:marvin, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

import_config "#{Mix.env()}.exs"
