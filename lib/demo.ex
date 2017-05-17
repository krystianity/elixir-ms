defmodule ExTest.Demo do

  alias MSBase.Log
  alias ExTest.Redis
  alias ExTest.Cassandra
  alias ExTest.KafkaConsumer
  alias ExTest.Ecto
  alias MsBase.Request

  def run() do

    MsBase.BannerGen.read_banner()

    test_jit_config()
    run_logger()
    run_redis()
    #run_kafka()
    #run_cassandra()
    run_ecto()
    run_uuid()
    run_http_client()

    :ok
  end

  defp run_logger() do

    log_level = Application.get_env(:ex_test, :log_level)
    service_name = Application.get_env(:ex_test, :service_name)
    json_enabled = Application.get_env(:ex_test, :json_enabled)

    Log.init(log_level, service_name, json_enabled)
    Log.info "Application ready."
  end

  defp test_jit_config() do
    # start with EXMS_TEST=123 mix run --no-halt # to pass env variables to weave
    IO.inspect Application.get_env(:ex_test, :TEST)
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
    :ok
  end

  defp run_ecto() do
    Ecto.keyword_query()
    Ecto.pipe_query()
  end

  defp run_uuid() do
    UUID.uuid4() |> IO.puts
  end

  defp run_http_client() do
     Request.start
     IO.inspect Request.get!("/users/krystianity").body[:public_repos]
  end

end
