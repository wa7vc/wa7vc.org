use Mix.Config
#
# Print only warnings and errors during test
config :logger, level: :warn

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wa7vc_web, Wa7vcWeb.Endpoint,
  http: [port: 4001],
  server: false
