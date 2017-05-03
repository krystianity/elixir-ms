defmodule Config.Handler do
  @moduledoc false

    def handle_configuration(key, value) do
        {:ex_test, String.to_atom(key), value}
    end
end
