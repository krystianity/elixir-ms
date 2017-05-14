defmodule ExTest.Router do
  use Plug.Router

  alias MSBase.Log

  # plug pipeline

  plug MSBase.AccessLog
  plug :match
  plug Plug.Parsers, parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  plug :dispatch

  # sub router forwarding

  forward "/admin", to: ExTest.AdminRouter
  forward "/metrics", to: ExTest.MetricsRouter
  forward "/ecto", to: ExTest.EctoRouter

  # pattern matching

  get "/" do

    Log.debug("someone called index", conn)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ExTest")
  end

  get "/example" do
    {:ok, string} = Poison.encode(%ExTest.ResDto{
      a_string: "some text",
      a_number: 123,
      a_list: ["of", "items"]
    })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, string)
  end

  post "/example" do
    case conn.body_params do
      %{"accepted" => value} ->
        send_resp(conn, 200, value)
      _ ->
        send_resp(conn, 400, "key 'accepted' not found in request body")
    end
  end

  match _ do
    send_resp(conn, 404, "unavailable")
  end

end
