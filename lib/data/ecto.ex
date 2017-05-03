defmodule ExTest.Ecto do
    import Ecto.Query

    def keyword_query do
        query = from w in ExTest.Schemas.Test,
        where: w.id > 0 or is_nil(w.bla),
        select: w
        res = ExTest.Repos.Test.all(query)
        IO.inspect res
        res
    end

    def pipe_query do
        ExTest.Schemas.Test
        |> where(id: 1)
        |> order_by(:id)
        |> limit(1)
        |> ExTest.Repos.Test.all
    end
end
