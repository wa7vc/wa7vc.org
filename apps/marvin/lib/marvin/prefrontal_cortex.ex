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
  end

  # Get the value for the given key, stripping it out of the {key,value} tuple.
  # Returns :error if key isn't found.
  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, val}] -> val
      [] -> :error
    end
  end

  # Get a value that's assumed to be a counter.
  # Because the counter may not have been created yet, we'll default to 0 if the key isn't found.
  def getcounter(key) do
    case val = get(key) do
      :error -> 0
      _ -> val
    end
  end

  # Update a counter (atomically) at the given key. Defaults the value to 0 if the key doesn't already exist.
  # Defaults to incrementing the value by 1, unless you provide an amount to increment by
  # Returns the new value of the counter.
  def increment(key, amount \\ 1) do
    :ets.update_counter(__MODULE__, key, amount, {key, 0})
  end

  #####
  # Server
  #####
  def init(_) do
    :ets.new(__MODULE__, [:set, :named_table, :public, write_concurrency: true, read_concurrency: true])
    {:ok, %{}}
  end
end
