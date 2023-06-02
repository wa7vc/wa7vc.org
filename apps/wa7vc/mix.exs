defmodule Wa7vcWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wa7vc,
      version: "0.3.17",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      {:phoenix, "~> 1.7.2"},
      # Unused Ecto deps from a clean 1.7.0 install
      #{:phoenix_ecto, "~> 4.4"},
      #{:ecto_sql, "~> 3.6"},
      #{:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.18.8"},
      {:heroicons, "~> 0.5"}, # Import just to make the default core_components work for now
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1.8", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.3"},
      {:plug_cowboy, "~> 2.0"},

      {:phoenix_pubsub, "~> 2.0"},
      {:plug, "~> 1.7"},
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
      #setup: ["deps.get", "ecto.setup"],
      #"ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      #"ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["test"],
      #test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end

end
