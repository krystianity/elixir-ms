defmodule MSBase.Log do

    @moduledoc  """
        Log
    """

  alias MSBase.Registry
  alias MSBase.AccessLog

  def init(level, service_name, json_enabled) do

    {:ok, hostname} = :inet.gethostname()
    color = System.get_env("SERVICE_COLOR")
    pid = System.get_pid()

    Registry.set("log-options", %{
      "level": level,
      "service": service_name,
      "host": List.to_string(hostname),
      "pid": pid,
      "color": color,
      "json": json_enabled
    })

    :ok
  end

  defp get_options() do
    {:ok, options} = Registry.get("log-options")
    options
  end

  defp get_value_for_level(level) do
    case level do
      "TRACE" ->
        10
      "DEBUG" ->
        20
      "INFO" ->
        30
      "WARN" ->
        40
      "ERROR" ->
        50
      "FATAL" ->
        60
      _ ->
        0
    end
  end

  defp get_iso_time do
    DateTime.to_iso8601 DateTime.utc_now()
  end

  defp get_json_log_msg(msg, level, options, corr_id) do

    {:ok, string} = Poison.encode(%MSBase.LogMsg{
        msg: msg,
        loglevel: level,
        loglevel_value: get_value_for_level(level),
        "@timestamp": get_iso_time(),
        pid: options.pid,
        current_color: options.color,
        service: options.service,
        host: options.host,
        "correlation-id": corr_id,
        beam_pid: "#{:erlang.pid_to_list(self())}",
        node: "#{node()}"
    })

    string
  end

  defp get_plain_log_msg(msg, level) do
    {:ok, string} = Poison.encode(msg)
    Enum.join([
        get_iso_time(),
        "-",
        level <> ":",
        string
    ], " ")
  end

  defp write_log(msg, level, color) when is_binary(level) do
    options = get_options()

    string = if options.json do
      get_json_log_msg(msg, level, options, nil)
    else
      get_plain_log_msg(msg, level)
    end

    [color, string]
    |> Bunt.puts

    :ok
  end

  defp write_log(msg, level, color, conn) when is_binary(level) do
      options = get_options()

      corr_id = AccessLog.read_correlation_id(conn)

      string = if options.json do
        get_json_log_msg(msg, level, options, corr_id)
      else
        get_plain_log_msg(msg, level)
      end

      [color, string]
      |> Bunt.puts

      :ok
    end

  def trace(msg) do
    write_log(msg, "TRACE", :white)
  end

  def debug(msg) do
    write_log(msg, "DEBUG", :aqua)
  end

  def info(msg) do
    write_log(msg, "INFO", :green)
  end

  def warn(msg) do
    write_log(msg, "WARN", :yellow)
  end

  def error(msg) do
    write_log(msg, "ERROR", :red)
  end

  def fatal(msg) do
    write_log(msg, "FATAL", :darkmagenta)
  end

  def trace(msg, conn) do
    write_log(msg, "TRACE", :white, conn)
  end

  def debug(msg, conn) do
     write_log(msg, "DEBUG", :aqua, conn)
  end

  def info(msg, conn) do
     write_log(msg, "INFO", :green, conn)
  end

  def warn(msg, conn) do
    write_log(msg, "WARN", :yellow, conn)
  end

  def error(msg, conn) do
    write_log(msg, "ERROR", :red, conn)
  end

  def fatal(msg, conn) do
    write_log(msg, "FATAL", :darkmagenta, conn)
  end

end
