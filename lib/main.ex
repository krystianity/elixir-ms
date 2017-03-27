defmodule ExTest do
    use Application

  # see mix.exs (defp applications)
  def start(_type, _args) do

    link_res = ExTest.Supervisor.start_link

    ExTest.Demo.run()

    link_res
  end

end
