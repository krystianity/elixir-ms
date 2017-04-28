defmodule ExTest.Mixfile do
  use Mix.Project

  def project do
    [
        app: :ExTest,
        version: "1.0.0",
        elixir: "~> 1.3",
        build_embedded: Mix.env == :prod,
        start_permanent: Mix.env == :prod,
        deps: deps()
    ]
  end

  def application do
    [
        mod: {ExTest, []},
        applications: [
            :prometheus_ex,
            :httpoison,
            :cowboy,
            :plug,
            #:kafka_consumer,
            :gproc,
            #:xandra
        ]
    ]
  end

  defp deps do
    [
        {:poison, "~> 3.1"}, # json parser
        {:httpoison, "~> 0.11"}, # http client
        #{:redix, "~> 0.5"}, # redis
        {:redix_pubsub, "~> 0.2.0"}, # redis pubsub actions (ships with redix)
        {:cowboy, "~> 1.1"}, # http server
        {:plug, "~> 1.3"}, # http server wrapper
        {:bunt, "~> 0.1.0"}, # cli colors
        {:prometheus_ex, "~> 1.1.0"}, # metrics
        #{:kafka_ex, "~> 0.6.3"}, # kafka client
        {:kafka_consumer, "~> 1.2.0"}, # easier kafka consumer (ships with kafka_ex & poolboy)
        {:xandra, "~> 0.5.0"} # cassandra driver
    ]
  end

end
