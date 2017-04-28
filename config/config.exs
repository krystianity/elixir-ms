use Mix.Config

    config :ExTest,

        port: 8080,

        log_level: "info",
        service_name: "ex-test",
        json_enabled: false,

        kafka_topic: "user-behaviour-tracking",

        cassandra_host: "127.0.0.1",
        cassandra_port: 9042,

        redis_host: "127.0.0.1",
        redis_port: 6379

    config :kafka_ex,

        brokers: [{"127.0.0.1", 9092}],
        consumer_group: "kafka_ex",
        sync_timeout: 3000,
        max_restarts: 10,
        max_seconds: 60,
        use_ssl: false

    config :kafka_consumer,

        default_pool_size: 5,
        default_pool_max_overflow: 10,
        event_handlers: [
            #{
                #ExTest.KafkaConsumer,
                #[
                #    {"access-log", 0}
                #],
                #size: 5,
                #max_overflow: 5
            #}
        ]

env_config = Path.expand("#{Mix.env}.exs", __DIR__)
if File.exists?(env_config) do
    import_config(env_config)
end