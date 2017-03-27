defmodule ExTest.Cassandra do

  alias MSBase.Registry

  def init do
    {:ok, conn} = Xandra.start_link(
        host: Application.get_env(:ExTest, :cassandra_host),
        port: Application.get_env(:ExTest, :cassandra_port)
    )

    Registry.set("cassandra-conn", conn)
    {:ok, conn}
  end

  def void_query(statement, _params) do
    {:ok, conn} = Registry.get "cassandra-conn"
    {:ok, %Xandra.Void{}} = Xandra.execute(conn, statement, _params)
  end

  def list_query(statement, _params) do
    {:ok, conn} = Registry.get "cassandra-conn"
    {:ok, %Xandra.Page{}} = Xandra.execute(conn, statement, _params)
  end

  def prepare(statement) do
    {:ok, conn} = Registry.get "cassandra-conn"
    {:ok, prepared} = Xandra.prepare(conn, statement)
  end

end