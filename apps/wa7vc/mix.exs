defmodule Wa7vcWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wa7vc,
      version: "0.2.1",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Wa7vc.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon, :timex, :sentry]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.5"},
      # Unused Ecto deps from a clean 1.5.4 install
      #{:phoenix_ecto, "~> 4.1"},
      #{:ecto_sql, "~> 3.4"},
      #{:postgrex, ">= 0.0.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_live_view, "~> 0.14.2"},  # Clean 1.5.4 install uses 0.13.0
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.0"},
      {:number, "~> 0.5.7"},
      {:timex, "~> 3.1"},
      {:sentry, "~> 8.0"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:libcluster, "~> 3.2"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      test: ["test"]
      #setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      #"ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      #"ecto.reset": ["ecto.drop", "ecto.setup"],
      #test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

end
