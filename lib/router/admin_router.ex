defmodule ExTest.AdminRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/healthcheck" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "")
  end

  get "/health" do
    {:ok, string} = Poison.encode(%{
          "status": "UP",
          "kafka": ExTest.KafkaConsumer.get_stats()
                                  })
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, string)
  end

  match _ do
    send_resp(conn, 404, "unavailable")
  end

end
