defmodule MSBase.LogMsg do
  @derive [Poison.Encoder]
  defstruct [
    "@timestamp": "",
    host: "",
    pid: "",
    loglevel: "",
    loglevel_value: "",
    log_type: "application",
    application_type: "service",
    service: "",
    current_color: "",
    msg: ""
  ]
end
