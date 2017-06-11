defmodule ExTest.Cassandra do
  use GenServer
  alias MSBase.Registry

  @process_key "cassandra-genserver"

  def start(_) do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil)
    Registry.set(@process_key, pid)
  end

  def init() do
    {:ok, conn} = Xandra.start_link(
        host: Application.get_env(:ex_test, :cassandra_host),
        port: Application.get_env(:ex_test, :cassandra_port)
    )

    Registry.set(@process_key, conn)
    {:ok, conn}
  end

  def void_query(statement, params) do
    {:ok, pid} = Registry.get(@process_key)
    GenServer.cast(pid, {:void_query, statement, params})
  end

  def list_query(statement, params) do
    {:ok, pid} = Registry.get(@process_key)
    GenServer.call(pid, {:list_query, statement, params})
  end

  def prepare(statement) do
    {:ok, pid} = Registry.get(@process_key)
    GenServer.call(pid, {:prepare, statement})
  end

  def handle_cast({:void_query, statement, params}, state) do
    {:ok, conn} = Registry.get "cassandra-conn"
    {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, params)
    {:noreply, state}
  end

  def handle_call({:list_query, statement, params}, _, state) do
    {:ok, conn} = Registry.get "cassandra-conn"
    {:ok, %Xandra.Page{} = page} = Xandra.execute(conn, statement, params)
    {:reply, page, state}
  end

  def handle_call({:prepare, statement}, _, state) do
    {:ok, conn} = Registry.get "cassandra-conn"
    {:ok, prepared} = Xandra.prepare(conn, statement)
    {:reply, prepared, state}
  end

end
