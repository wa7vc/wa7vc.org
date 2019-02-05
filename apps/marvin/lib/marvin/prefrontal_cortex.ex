defmodule Marvin.PrefrontalCortex do
  use GenServer

  #####
  # Client API
  #####
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get(key) do
    [{_key, val}] = :ets.lookup(__MODULE__, key)
    val
  end

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
