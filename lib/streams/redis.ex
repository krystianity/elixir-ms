defmodule ExTest.Redis do
    use GenServer

    alias MSBase.Log

     def start_link(channel) do
        GenServer.start_link(__MODULE__, channel)
      end

    def init(channel) do

      host = Application.get_env(:ExTest, :redis_host)
      port = Application.get_env(:ExTest, :redis_port)

      {:ok, conn} = Redix.PubSub.start_link(host: host, port: port)

      Redix.PubSub.subscribe(conn, channel, self())

        # await subscription of channel
        receive do
          {:redix_pubsub, ^conn, :subscribed, %{channel: channel}} ->
          Log.info("redis subscribed to channel #{channel}.")
          {:ok, %{channel: channel}}
          after
          200 ->
          Log.error("failed to subscribe to redis channel #{channel}.")
          {:stop, "redis subscription failed"} # :stop is a convention here
        end
    end

    def handle_info({:redix_pubsub, _, :message, %{channel: channel, payload: payload}}, state) do
        Log.debug("received redis message on channel #{channel} with payload #{payload}")
        #do something here
        {:noreply, state}
     end
end