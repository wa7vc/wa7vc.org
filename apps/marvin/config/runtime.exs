import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.


if config_env() == :prod do
  # Get the IRC password for Marvin's primary IRC network
  marvin_irc_password =
    System.get_env("MARVIN_IRC_PASSWORD") ||
      raise """
      environment variable MARVIN_IRC_PASSWORD is missing.
      """

  # Get the Sentry.io DSN for the Marvin app
  marvin_sentry_dsn =
    System.get_env("MARVIN_SENTRY_DSN") ||
      raise """
      environment variable MARVIN_SENTRY_DSN is missing.
      """

  config :marvin, Marvin.IrcRobot,
    password: marvin_irc_password

  config :sentry,
    dsn: marvin_sentry_dsn
end
