defmodule ExTest.Supervisor do
  use Supervisor

  alias MSBase.Registry

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ExTest.Router, [], [
          port: Application.get_env(:ExTest, :port)
      ]),
      worker(Registry, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

end
