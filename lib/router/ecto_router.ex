defmodule ExTest.EctoRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/test" do
    changeset = Ecto.Changeset.cast(%ExTest.Schemas.Test{}, conn.body_params, [:mach_doch])
    result = ExTest.Repos.Test.insert!(changeset)
    IO.inspect result

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "{}")
  end

  get "/test" do

    result = ExTest.Ecto.any_query()
    IO.inspect result

    {:ok, string} = Poison.encode(%{
        result: result
    })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, string)
  end

  match _ do
    send_resp(conn, 404, "unavailable")
  end

end
