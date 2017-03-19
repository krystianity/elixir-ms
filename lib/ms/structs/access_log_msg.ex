defmodule MSBase.AccessLogMsg do
  @derive [Poison.Encoder]
  defstruct [
    "@timestamp": "",
    host: "",
    loglevel: "INFO",
    "correlation-id": "",
    application_type: "service",
    status: "",
    service: "",
    log_type: "access",
    request_method: "",
    uri: "",
    query_string: "",
    response_time: "",
    protocol: "HTTP",
    server_name: "",
    current_color: "",
    remote_client_id: "",
    bytes_received: "0",
    bytes_sent: "0"
  ]
end
