defmodule ExTest.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_test,
      version: "1.0.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
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
        :postgrex,
        #:kafka_consumer,
        :gproc,
        #:xandra
      ]
    ]
  end

  defp aliases do
    [
      start: ["clean", "compile", "run --no-halt"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.7", only: [:dev, :test]}, # linting
      {:poison, "~> 3.1"}, # json parser
      {:httpoison, "~> 0.11"}, # http client
      #{:redix, "~> 0.5"}, # redis
      {:redix_pubsub, "~> 0.2.0"}, # redis pubsub actions (ships with redix)
      {:cowboy, "~> 1.1"}, # http server
      {:plug, "~> 1.3"}, # http server wrapper
      {:bunt, "~> 0.2.0"}, # cli colors
      {:prometheus_ex, "~> 1.1.0"}, # metrics
      #{:kafka_ex, "~> 0.6.3"}, # kafka client
      {:kafka_consumer, "~> 1.2.0"}, # easier kafka consumer (ships with kafka_ex & poolboy)
      {:xandra, "~> 0.5.0"}, # cassandra driver
      {:weave, "~> 1.0.0"}, # JIT config
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}, # static analysis
      {:postgrex, "~> 0.13.2"}, #postgres driver
      {:ecto, "~> 2.1.0"}, #db orm
    ]
  end

end
