defmodule MSBase.AccessLogTest do
  use ExUnit.Case
  use Plug.Test

  import ExUnit.CaptureIO

  alias MSBase.AccessLog

  defp apply_request_headers(test_conn, request_headers) do
    Enum.reduce(
      request_headers,
      test_conn,
      fn({key, value}, c) ->
        Plug.Conn.put_req_header(c, key, value)
      end)
  end

  defp run_conn(url, request_headers \\ []) do
    run_plug = fn ->
      conn(:get, url, "")
      |> apply_request_headers(request_headers)
      |> AccessLog.call(%{})
      |> resp(200, "response")
      |> send_resp
    end

    {:ok, log_msg} = Poison.decode(capture_io(run_plug), as: %MSBase.AccessLogMsg{})
    log_msg
  end

  test "logs request information and access log fields" do
    log_msg = run_conn("/product?id=123")

    #TODO match against map
    assert log_msg.uri == "/product"
    assert log_msg.application_type == "service"
    assert log_msg.log_type == "access"
    assert log_msg.loglevel == "INFO"
    assert log_msg.request_method == "GET"
    assert log_msg.service == "ex_test"
    assert log_msg.status == "200"
    assert log_msg.protocol == "HTTP"
    assert log_msg.query_string == "id=123"
  end

  test "logs the timestamp" do
    unix_time_start = DateTime.utc_now() |> DateTime.to_unix(:microsecond)
    log_msg = run_conn("/")

    {:ok, time_log, _} = DateTime.from_iso8601(log_msg."@timestamp")
    unix_time_log = time_log |> DateTime.to_unix(:microsecond)
    diff = unix_time_log - unix_time_start

    assert_in_delta(diff, 1, 10000)
  end

  test "logs beam specific fields" do
    {:ok, hostname} = :inet.gethostname()
    log_msg = run_conn("/")

    assert log_msg.beam_pid == "#{:erlang.pid_to_list(self())}"
    assert log_msg.node == "#{node()}"
    assert log_msg.host == hostname
  end

  test "logs the current color" do
    System.put_env("SERVICE_COLOR", "green")
    log_msg = run_conn("/")

    assert log_msg.current_color == "green"
  end

  test "logs the request duration" do
    duration_regex = ~r/(?<duration>\d+) (?<unit>ms|µs)/

    log_msg = run_conn("/")
    %{"duration" => duration_string, "unit" => unit} = Regex.named_captures(duration_regex, log_msg.response_time)
    duration = String.to_integer(duration_string)

    assert_in_delta(duration, 1, 999)
    assert unit == "ms" || unit == "µs"
  end

  test "logs the correlation-id" do
    correlation_id = "abc-123"
    log_msg = run_conn("/", [{"correlation-id", correlation_id}])

    assert log_msg."correlation-id" == correlation_id
  end

  test "logs the customer-uuid as the remote_client_id if present" do
    customer_uuid = "007-customer"
    log_msg = run_conn(
      "/",
      [
        {"customer-uuid", customer_uuid},
        {"auth-info-user-id", "not_this"}
      ]
    )

    assert log_msg.remote_client_id == customer_uuid
  end

  test "logs the auth-info-user-id as the remote_client_id as a fallback to customer-uuid" do
    auth_info_user_id = "auth-info-user-01"
    log_msg = run_conn("/", [{"auth-info-user-id", auth_info_user_id}])

    assert log_msg.remote_client_id == auth_info_user_id
  end

  test "logs unknown as remote_client_id if no customer-uuid and auth-info-user-id header present" do
    log_msg = run_conn("/")

    assert log_msg.remote_client_id == "unknown"
  end

  test "logs host header as server name" do
    host = "127.0.0.1"
    log_msg = run_conn("/", [{"host", host}])

    assert log_msg.server_name == host
  end

  test "logs unknown as server name if host header not present" do
    log_msg = run_conn("/")

    assert log_msg.server_name == "unknown"
  end
end
