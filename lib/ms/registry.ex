defmodule MSBase.Registry do
  use GenServer

  @moduledoc """
  Registry
  """

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end

  # "client-side" code

  # call awaits a return
  def get(key) when is_bitstring(key) do
    GenServer.call(:registry, {:lookup, key})
  end

  # cast is fire & forget
  def set(key, value) when is_bitstring(key) do
    GenServer.cast(:registry, {:create, key, value})
  end

  def all do
    GenServer.call(:registry, {:all})
  end

  # "server-side" code

  # init is synchronous
  def init(_) do
    init_state = %{}
    {:ok, init_state}
  end

  def handle_call({:lookup, key}, _from, state) do
    {:reply, Map.fetch(state, key), state}
  end

  def handle_call({:all}, _from, state) do
    {:reply, state, state}
  end

  # map is immutable, Map.put will create new map
  # :noreply is sent back to genserver

  # newState is passed via genserver

  def handle_cast({:create, key, value}, state) do
    new_state = Map.put(state, key, value)
    {:noreply, new_state}
  end
end
