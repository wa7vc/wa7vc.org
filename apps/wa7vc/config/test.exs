import Config

# Print only warnings and errors during test
config :logger, level: :warn

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wa7vc, Wa7vcWeb.Endpoint,
  http: [port: 4001],
  server: false,
  github_webhook_secret: "LK44/Ayqlqr8oBB0mzKyRX5aQBaxU1WE4fvae5VlIHrYq8mYnqLcAOPAX8jtU4A5" 
