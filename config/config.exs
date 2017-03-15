use Mix.Config

    config :logger,
        level: :info,
        format: "$time $metadata[$level] $levelpad$message\n"