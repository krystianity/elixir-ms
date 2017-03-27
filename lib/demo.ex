defmodule ExTest.Demo do

  alias MSBase.Log
  alias ExTest.Redis
  alias ExTest.Cassandra

  def run() do
    run_logger()
    run_redis()

    :ok
  end


  defp run_logger() do

    log_level = Application.get_env(:ExTest, :log_level)
    service_name = Application.get_env(:ExTest, :service_name)
    json_enabled = Application.get_env(:ExTest, :json_enabled)

    Log.init(log_level, service_name, json_enabled)
    Log.info "Application ready."
  end

  defp run_redis() do

    Redis.init()
    channel = "ex-test-channel"

    func = fn msg ->
        IO.inspect msg
     end

    redis_pid = spawn(fn ->
         Redis.subscribe(channel, func)
     end)

     Redis.publish(channel, "bla bla bla")
  end

  defp run_cassandra() do

    Cassandra.init()

  end

end