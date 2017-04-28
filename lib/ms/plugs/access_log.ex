defmodule MSBase.AccessLog do

    @moduledoc """
       Access Log
    """

  alias Plug.Conn
  @behaviour Plug

  def init(opts) do
    opts
  end

  def call(conn, _) do

    start = System.monotonic_time()

    Conn.register_before_send(conn, fn conn ->

        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :micro_seconds)

        status = Integer.to_string(conn.status)
        formatted_diff = Enum.join(formatted_diff(diff), " ")

        conn
        |> get_json_log(status, formatted_diff)
        |> write_log

      conn
    end)
  end

  defp get_iso_time do
    DateTime.to_iso8601 DateTime.utc_now()
  end

  def read_correlation_id(conn) do
    #{_, value} = List.keyfind(conn.req_headers,"correlation-id",0)
    List.first Plug.Conn.get_req_header(conn, "correlation-id")
  end

  defp get_json_log(conn, status, response_time) do
    {:ok, string} = Poison.encode(%MSBase.AccessLogMsg{
        status: status,
        response_time: response_time,
        service: "ex_test",
        request_method: conn.method,
        uri: "/" <> Enum.join(conn.path_info, "/"),
        query_string: conn.query_string,
        "@timestamp": get_iso_time(),
        "correlation-id": read_correlation_id(conn),
        beam_pid: "#{:erlang.pid_to_list(self())}",
        node: "#{node()}"
    })
    string
  end

  defp write_log(string) do
    IO.puts string
    {:ok}
  end

  defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string, "ms"]
  defp formatted_diff(diff), do: [Integer.to_string(diff), "µs"]
end
