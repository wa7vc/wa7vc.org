defmodule Wa7vcWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wa7vc,
      version: "0.3.14",
      elixir: "~> 1.12",
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
      {:phoenix, "~> 1.6.0"},
      # Unused Ecto deps from a clean 1.5.4 install
      #{:phoenix_ecto, "~> 4.1"},
      #{:ecto_sql, "~> 3.4"},
      #{:postgrex, ">= 0.0.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.7"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.3"},
      {:number, "~> 1.0.3"},
      {:timex, "~> 3.7"},
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
      setup: ["deps.get"],
      test: ["test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      #setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      #"ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      #"ecto.reset": ["ecto.drop", "ecto.setup"],
      #test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

end
