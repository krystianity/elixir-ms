defmodule ExTest do
  use Application

  # see mix.exs (defp applications)
  def start(_type, _args) do

    Weave.Loaders.Environment.load_configuration()
    link_res = ExTest.Supervisor.start_link()

    ExTest.Demo.run()

    link_res
  end

end
