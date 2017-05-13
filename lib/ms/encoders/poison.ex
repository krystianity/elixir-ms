defimpl Poison.Encoder, for: Any do
    # this encoder is required when trying to json stringify
    # ecto query results, as they may contain private data
    # that will throw exceptions per default

  def encode(%{__struct__: _} = struct, options) do
    map = struct
          |> Map.from_struct
          |> sanitize_map
    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end
end
