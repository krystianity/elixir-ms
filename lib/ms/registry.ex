defmodule MSBase.Registry do
    use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :registry)
  end

  def get(key) when is_bitstring(key) do
    GenServer.call(:registry, {:lookup, key})
  end

  def set(key, value) when is_bitstring(key) do
    GenServer.cast(:registry, {:create, key, value})
  end

  def all do
    GenServer.call(:registry, {:all})
  end

  def init do
    {:ok, %{}}
  end

  def handle_call({:lookup, key}, _from, stored) do
    {:reply, Map.fetch(stored, key), stored}
  end

  def handle_call({:all}, _from, stored) do
    {:reply, stored, stored}
  end

  def handle_cast({:create, key, value}, stored) do
      stored = Map.put(stored, key, value)
      {:noreply, stored}
  end
end
