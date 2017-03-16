defmodule ExTest.Router do
    use Plug.Router

  # plug pipeline

  plug ExTest.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass: ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  # pattern matching

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ExTest")
  end

  get "/j" do
    {:ok, string} = Poison.encode(%ExTest.ResDto{
        one: "eins",
        two: "zwei",
        three: "drei"
    })
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, string)
  end

  post "j" do
    %{"derp" => value} = body = conn.body_params
    IO.inspect body
    send_resp(conn, 200, body["derp"])
  end

 #forward "/users", to: UsersRouter

  match _ do
    send_resp(conn, 404, "unavailable")
  end

end