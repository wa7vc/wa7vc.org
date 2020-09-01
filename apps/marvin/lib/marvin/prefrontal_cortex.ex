defmodule Marvin.PrefrontalCortex do
  use GenServer
  alias Marvin.PubSub

  #####
  # Client API
  #####
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Insert a {key,value} tuple into, updated the value of the key already exists.
  def put(key, value) do
    :ets.insert(__MODULE__, {key, value})
    PubSub.broadcast("prefrontal_cortex", "key:updated", %{:key => key, :value => value})
    #PubSub.broadcast("prefrontal_cortex:#{key}", "key:updated", %{:key => key, :value => value})
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
    new_val = :ets.update_counter(__MODULE__, key, amount, {key, 0})
    PubSub.broadcast("prefrontal_cortex", "key:updated", %{:key => key, :value => new_val})
    #PubSub.broadcast("prefrontal_cortex:#{key}", "key:updated", %{:key => key, :value => new_val})
    new_val
  end

  # Sign up for notifications about every value change made
  def subscribe do
    PubSub.subscribe("prefrontal_cortex")
  end

  # Sign up for notifications about specific keys.
  # NOTE: Decided this was premature optimization, keeping but commenting out as a possible future thing if we need to figure
  #       out the right way to handle subscribing to just specific topics.
  #def subscribe(key) do
    #PubSub.subscribe("prefrontal_cortex:#{key}")
  #end



  #####
  # Server
  #####
  def init(_) do
    :ets.new(__MODULE__, [:set, :named_table, :public, write_concurrency: true, read_concurrency: true])
    {:ok, %{:bootup_timestamp => Timex.now()}}
  end

end
