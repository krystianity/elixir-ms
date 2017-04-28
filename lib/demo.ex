defmodule ExTest.Demo do

  alias MSBase.Log
  alias ExTest.Redis
  alias ExTest.Cassandra
  alias ExTest.KafkaConsumer

  def run() do

    run_logger()
    run_redis()
    #run_kafka()
    #run_cassandra()

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

     channel = "ex-test-channel"
    Redis.start_link(channel)
  end

  defp run_cassandra() do
    Cassandra.init()
  end

  defp run_kafka() do

    KafkaConsumer.get_partition_config("access-log")
    |> IO.inspect

    :ok
  end

end