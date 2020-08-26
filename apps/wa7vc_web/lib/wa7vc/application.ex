defmodule Wa7vc.Application do
  @moduledoc false

  use Application

  @env Mix.env()

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Wa7vcWeb.PubSub},
      # Start the Telemetry Supervisor
      Wa7vcWeb.Telemetry,
      # Start the endpoint when the application starts
      supervisor(Wa7vcWeb.Endpoint, []),
      # Start a worker by calling: Chirp.Worker.start_link(arg)
      # {Chirp.Worker, arg}
    ]

    start_sub_applications()

    children = Enum.reject(children, &is_nil/1)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wa7vc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Wa7vcWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp start_sub_applications() do
    if @env == :dev do
      :application.start(:marvin)
    end
  end
end
