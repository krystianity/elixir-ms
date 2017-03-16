defmodule ExTest do
    use Application

  def start(_type, _args) do

    children = [
        Plug.Adapters.Cowboy.child_spec(:http, ExTest.Router, [], [
            port: 8080
        ])
    ]

    opts = [
        strategy: :one_for_one,
        name: ExTest.Supervisor
    ]

    IO.puts "Application ready."
    Supervisor.start_link(children, opts)
  end

end