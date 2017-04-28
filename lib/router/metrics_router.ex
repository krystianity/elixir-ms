defmodule ExTest.MetricsRouter do
    use Plug.Router

    require Prometheus.Format.Text

    plug :match
    plug :dispatch

    # checkout: https://github.com/deadtrickster/prometheus.ex/blob/master/test/format/text_test.exs
    # for custom metrics

    get "/" do
      format = Prometheus.Format.Text.format(:default)
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, format)
    end

    match _ do
      send_resp(conn, 404, "unavailable")
    end
end
