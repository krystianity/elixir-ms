defmodule MsBase.BannerGen do
    #http://patorjk.com/software/taag/#p=display&f=Chiseled&t=elixir

  def read_banner() do

    banner_path = Path.expand("config/banner.txt", File.cwd!())

    if File.exists?(banner_path) do
        File.stream!(banner_path) |> Stream.each(fn line -> IO.write(line) end) |> Stream.run
    end

    :ok
  end
end
