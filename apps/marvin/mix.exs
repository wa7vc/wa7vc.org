defmodule Marvin.MixProject do
  use Mix.Project

  def project do
    [
      app: :marvin,
      version: "0.3.12",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Marvin.Application, []},
      extra_applications: [:logger, :hedwig_irc_adapter, :timex, :sentry]
    ]
  end

  #
  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hedwig_irc_adapter, "~> 0.1.0"}, # Use the daynyxx fork which has been updated to more recent Hedwig/ExIRC versions
      {:sentry, "~> 8.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.3"},     # Pin to same version as wa7vc_web uses
      {:timex, "~> 3.7"},     # Pin to same version as wa7vc_web uses
      {:number, "~> 1.0.3"},  # Pin to same version as wa7vc_web uses
      {:aprs_parse, "~> 0.1.0"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:libcluster, "~> 3.2"},
      {:con_cache, "~> 1.0"},
      {:mox, "~> 1.0.0", only: :test},
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      test: ["test"],
    ]
  end
end
