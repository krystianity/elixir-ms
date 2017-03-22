defmodule ExTest do
    use Application

    alias MSBase.Log

    # see mix.exs (defp applications)

  def start(_type, _args) do
    #IO.puts "starting supervisor"
    link_res = ExTest.Supervisor.start_link
    #IO.puts "preparing side effects"
    side_effects()
    link_res
  end

  def side_effects do

    log_level = Application.get_env(:ExTest, :log_level)
    service_name = Application.get_env(:ExTest, :service_name)
    json_enabled = Application.get_env(:ExTest, :json_enabled)

    Log.init(log_level, service_name, json_enabled)
    Log.info "Application ready."

    {:ok}
  end

end
