defmodule Marvin.Application do
  @moduledoc """
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      cluster_supervisor(),
      phoenix_pubsub(),
      {Marvin.PrefrontalCortex, []},
      {Marvin.Hooker, []},
      {ConCache, [name: :aprs_beacon_1hr_cache, ttl_check_interval: :timer.seconds(30), global_ttl: :timer.seconds(60*60), callback: fn(data) -> Marvin.Aprs.handle_aprs_beacon_1hr_cache_callback(data) end]},
      Supervisor.child_spec({Task, fn -> Marvin.PrefrontalCortex.put(:bootup_timestamp, Timex.now()) end}, restart: :transient)
    ] ++ env_conditional_children(Application.get_env(:marvin, :environment))

    # Remove any nils from the list, from things like pubsub that may not be started
    children = Enum.reject(children, &is_nil/1)

    opts = [strategy: :one_for_one, name: Marvin.Supervisor]

    Sentry.capture_message("Marvin is starting up", level: "info", extra: %{version: Application.spec(:marvin, :vsn) |> to_string()})

    Supervisor.start_link(children, opts)
  end

  # Spitballing this one. 
  # TODO: figure out if this works or is right
  #def config_change(changed, _new, removed) do
  #  Marvin.Application.config_change(changed, removed)
  #  :ok
  #end


  defp env_conditional_children(:test), do: []
  defp env_conditional_children(_) do
    [
      {Marvin.IrcRobot, []},
      {Marvin.RiverGaugeMonitor, []},
      {Marvin.Aprs, []},
    ]
  end

  defp cluster_supervisor() do
    topologies = Application.get_env(:marvin, :topologies)

    if topologies do
      {Cluster.Supervisor, [topologies, [name: Marvin.ClusterSupervisor]]}
    end
  end

  defp phoenix_pubsub() do
    pubsub = Application.get_env(:marvin, :pubsub)

    if pubsub[:start] do
      {Phoenix.PubSub, [name: Wa7vc.PubSub]}
    end
  end


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
