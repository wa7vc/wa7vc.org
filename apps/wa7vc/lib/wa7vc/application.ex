defmodule Wa7vc.Application do
  @moduledoc false

  use Application

  @env Mix.env()

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    
    # Define workers and child supervisors to be supervised
    children = [
      cluster_supervisor(),
      # Start the PubSub system
      {Phoenix.PubSub, name: Wa7vc.PubSub},
      # Start the Telemetry Supervisor
      Wa7vcWeb.Telemetry,
      # Start the endpoint when the application starts
      Wa7vcWeb.Endpoint,
    ]


    # Remove any nils from the list, from things that might be conditionally started
    children = Enum.reject(children, &is_nil/1)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wa7vc.Supervisor]
    startup_val = Supervisor.start_link(children, opts)

    if @env == :dev, do: Application.ensure_all_started(:marvin)

    Sentry.capture_message("WA7VC is starting up", level: "info", extra: %{version: Application.spec(:wa7vc, :vsn) |> to_string()})

    startup_val
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Wa7vcWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp cluster_supervisor() do
    topologies = Application.get_env(:wa7vc, :topologies)

    if topologies do
      {Cluster.Supervisor, [topologies, [name: Wa7vc.ClusterSupervisor]]}
    end
  end

end
