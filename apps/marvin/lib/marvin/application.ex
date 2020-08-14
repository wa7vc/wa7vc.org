defmodule Marvin.Application do
  @moduledoc """
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    startup_tasks = [fn -> Marvin.PrefrontalCortex.put(:bootup_timestamp, Timex.now()) end]
    
    children = [
      {Phoenix.PubSub, name: :marvin_synapses},
      worker(Marvin.PrefrontalCortex, []),
      worker(Marvin.IrcRobot, []),
      worker(Marvin.Hooker, []),
      worker(Marvin.RiverGaugeMonitor, []),
      worker(Task, startup_tasks, restart: :transient),
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

  # Close enough wall-clock time to when the website went live for the first time
  def released() do
    {:ok, born_ts, 0} = DateTime.from_iso8601("2018-08-01T00:00:00Z")
    born_ts
  end

  def since_released(measure \\ :seconds) do
    case measure do
      :marvinyears -> Timex.diff(Timex.now(), released(), :seconds) * 1000
      _ -> Timex.diff(Timex.now(), released(), measure)
    end
  end

  def last_started() do
    Marvin.PrefrontalCortex.get(:bootup_timestamp)
  end
  
  # The number of "years" marvin has been alive since last boot, given that 1 second = 1000 years to him
  def lifespan(measure \\ :seconds) do
    case measure do
      :marvinyears -> Timex.diff(Timex.now(), last_started(), :seconds) * 1000
      _ -> Timex.diff(Timex.now(), last_started(), measure)      
    end
  end
end
