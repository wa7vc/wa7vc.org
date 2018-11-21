defmodule Marvin.MixProject do
  use Mix.Project

  def project do
    [
      app: :marvin,
      version: append_revision("0.0.5"),
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Marvin.Application, []},
      extra_applications: [:logger, :hedwig_irc]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},
      #{:hedwig_irc, "~> 0.1.0"}
      {:hedwig_irc, git: "git://github.com/jeffweiss/hedwig_irc.git"}
    ]
  end

  # Generate a dynamic version number automatically.
  def append_revision(version) do
    "#{version}+#{git_rev()}"
  end

  defp git_rev() do
    System.cmd("git", ["rev-parse", "--short", "HEAD"])
    |> elem(0)
    |> String.trim_trailing
  end
end
