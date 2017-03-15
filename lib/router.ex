defmodule ExTest.Router do
    use Plug.Router

  # plug pipeline
  plug ExTest.Logger
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ExTest")
  end

 #forward "/users", to: UsersRouter

  match _ do
    send_resp(conn, 404, "unavailable")
  end

end