defmodule ExTest.ResDto do
  @derive [Poison.Encoder]
  defstruct [
    :a_string,
    :a_number,
    :a_list
  ]
end
