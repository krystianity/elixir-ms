defmodule ExTest.ResDto do
  @derive [Poison.Encoder]
  defstruct [
    :one,
    :two,
    :three
  ]
end
