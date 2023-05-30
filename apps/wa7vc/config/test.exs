import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
#config :wa7vc, Wa7Vc.Repo,
  #username: "postgres",
  #password: "postgres",
  #hostname: "localhost",
  #database: "wa7vc_test#{System.get_env("MIX_TEST_PARTITION")}",
  #pool: Ecto.Adapters.SQL.Sandbox,
  #pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wa7vc, Wa7vcWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "O8wBdRZKLUTi7j0S4pxebjPdxOkYLaLzaQfHcoEFhJQAVdC7JE1WYcGLcKGlx654",
  github_webhook_secret: "LK44/Ayqlqr8oBB0mzKyRX5aQBaxU1WE4fvae5VlIHrYq8mYnqLcAOPAX8jtU4A5",
  server: false

# In test we don't send emails.
config :wa7vc, PhxExample.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
