defmodule ExTest.Redis do

    alias MSBase.Registry

    def init do

      host = Application.get_env(:ExTest, :redis_host)
      port = Application.get_env(:ExTest, :redis_port)

      {:ok, connSub} = Redix.PubSub.start_link(host: host, port: port)
      {:ok, connCom} = Redix.start_link(host: host, port: port)

      Registry.set("conn-sub", connSub)
      Registry.set("conn-com", connCom)

      {:ok, connSub, connCom}
    end

    # subscribe to a redis channel
    def subscribe(channel, cb) do
      {:ok, conn} = Registry.get("conn-sub")

      Redix.PubSub.subscribe(conn, channel, self())

      # await subscription of channel
      receive do
        {:redix_pubsub, ^conn, :subscribed, %{channel: channel}} -> :ok
      end

      #receive messages
      receive do
        {:redix_pubsub, ^conn, :message, %{channel: channel}} = properties ->
         cb.(properties)
         properties
      end # TODO build genserver to constantly reive messages

     {:ok, conn}
    end

    # unsubscribe to a redis channel
    def unsubscribe(channel) do
        {:ok, conn} = Registry.get("conn-sub")
        Redix.PubSub.unsubscribe(conn, channel, self())
    end

    # publish a message on a redis channel
    def publish(channel, message) do
        {:ok, conn} = Registry.get("conn-com")
        Redix.command!(conn, ["PUBLISH", channel, message])
    end

    def close() do
      {:ok, connSub} = Registry.get("conn-sub")
      {:ok, connCom} = Registry.get("conn-com")
      Redix.PubSub.stop(connSub)
      Redix.stop(connCom)
    end

end