defmodule Mix.Tasks.Docker do
  use Mix.Task

  def run(_) do
    Mix.Tasks.Cmd.run(~w(docker build -t ex-test:latest .))
    Mix.Tasks.Cmd.run(~w(docker run -i --rm --name ex-test -p 8080:8080 ex-test:latest))
  end
end
