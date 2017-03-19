defmodule MSBase.Log do

  alias MSBase.Registry

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

    {:ok}
  end

  def get_options() do
    {:ok, options} = Registry.get("log-options")
    options
  end

  def get_value_for_level(level) do
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

  def get_iso_time do
    DateTime.to_iso8601 DateTime.utc_now()
  end

  def get_json_log_msg(msg, level, options) do

    {:ok, string} = Poison.encode(%MSBase.LogMsg{
        msg: msg,
        loglevel: level,
        loglevel_value: get_value_for_level(level),
        "@timestamp": get_iso_time(),
        pid: options.pid,
        current_color: options.color,
        service: options.service,
        host: options.host
    })

    string
  end

  def get_plain_log_msg(msg, level) do
    {:ok, string} = Poison.encode(msg)
    Enum.join([
        get_iso_time(),
        "-",
        level,
        string
    ], " ")
  end

  def write_log(msg, level, color) do
    options = get_options()

    string = if options.json do
      get_json_log_msg(msg, level, options)
    else
      get_plain_log_msg(msg, level)
    end

    [color, string]
    |> Bunt.puts

    {:ok}
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

end
