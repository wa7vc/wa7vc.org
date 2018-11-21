defmodule Marvin.Application do
  @moduledoc """
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    children = [
      worker(Marvin.IrcRobot, []),
      worker(Marvin.Hooker, []),
    ]

    opts = [strategy: :one_for_one, name: Marvin.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Spitballing this one. 
  # TODO: figure out if this works or is right
  #def config_change(changed, _new, removed) do
  #  Marvin.Application.config_change(changed, removed)
  #  :ok
  #end
end
