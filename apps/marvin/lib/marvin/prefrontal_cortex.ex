defmodule Marvin.PrefrontalCortex do
  use GenServer

  #####
  # Client API
  #####
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Insert a {key,value} tuple into, updated the value of the key already exists.
  def put(key, value) do
    :ets.insert(__MODULE__, {key, value})
    broadcast(key, value)
  end

  # Get the value for the given key, stripping it out of the {key,value} tuple.
  # Returns :error if key isn't found.
  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, val}] -> val
      [] -> nil
    end
  end

  # Get a value that's assumed to be a counter.
  # Because the counter may not have been created yet, we'll default to 0 if the key isn't found.
  def get_counter(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, val}] -> val
      [] -> 0
    end
  end

  # Update a counter (atomically) at the given key. Defaults the value to 0 if the key doesn't already exist.
  # Defaults to incrementing the value by 1, unless you provide an amount to increment by
  # Returns the new value of the counter.
  def increment(key, amount \\ 1) do
    newVal = :ets.update_counter(__MODULE__, key, amount, {key, 0})
    broadcast(key, newVal)
    newVal
  end

  # Sign up for notifications about every value change made
  def subscribe do
    Phoenix.PubSub.subscribe(:marvin_synapses, "prefrontal_cortex")
  end

  # Sign up for notifications about every value change made
  def subscribe(key) do
    Phoenix.PubSub.subscribe(:marvin_synapses, "prefrontal_cortex:" <> key)
  end



  #####
  # Server
  #####
  def init(_) do
    :ets.new(__MODULE__, [:set, :named_table, :public, write_concurrency: true, read_concurrency: true])
    {:ok, %{}}
  end



  #
  # Broadcasts on pubsub :marvin_synapses, under the topics "prefrontal_cortex" and "prefrontal_cortex:KEY",
  # allow subscribers to subscribe only to certain keys, or to all key changes
  defp broadcast(k, v) do
    Phoenix.PubSub.broadcast(:marvin_synapses, "prefrontal_cortex", {:key_updated, {k,v}})
    #Phoenix.PubSub.broadcast(:marvin_synapses, "prefrontal_contex:" <> k, {:key_updated, %{key: k, value: v}})
  end
end
