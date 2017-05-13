defmodule ExTest.Supervisor do
  use Supervisor

  alias MSBase.Registry

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ExTest.Router, [], [
        port: Application.get_env(:ex_test, :port)
      ]),
      worker(Registry, []),
      worker(ExTest.Repos.Test, [])
    ]

    # a worker is a (erlang) process that has no other children

    supervise(children, strategy: :one_for_one)

    # (kills supervisor after 5 bad restarts of a worker)
    # one_for_one strategy keeps a single instance of the worker running
    # rest_for_one, once_for_all

  end

end
