defmodule ExTest.LogMsg do
  @derive [Poison.Encoder]
  defstruct [
    :status,
    :response_time,
    :service,
    :method,
    :path
  ]
end