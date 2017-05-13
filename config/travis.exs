use Mix.config

    config :ex_test, ExTest.Repos.Test,
           adapter: Ecto.Adapters.Postgres,
           database: "ex_test",
           username: "postgres",
           password: ""
