defmodule MSBase.AccessLog do

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
        fdiff = Enum.join(formatted_diff(diff), " ")

        get_json_log(conn, status, fdiff)
        |> write_log

      conn
    end)
  end

  def get_iso_time do
    DateTime.to_iso8601 DateTime.utc_now()
  end

  def read_correlation_id(conn) do
    {_, value} = List.keyfind(conn.req_headers,"correlation-id",0)
    value
  end

  def get_json_log(conn, status, response_time) do
    {:ok, string} = Poison.encode(%MSBase.AccessLogMsg{
        status: status,
        response_time: response_time,
        service: "ex_test",
        request_method: conn.method,
        uri: "/" <> Enum.join(conn.path_info, "/"),
        query_string: conn.query_string,
        "@timestamp": get_iso_time(),
        "correlation-id": read_correlation_id(conn)
    })
    string
  end

  def write_log(string) do
    IO.puts string
    {:ok}
  end

  defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string, "ms"]
  defp formatted_diff(diff), do: [Integer.to_string(diff), "µs"]
end
