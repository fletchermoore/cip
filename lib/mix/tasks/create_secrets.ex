defmodule Mix.Tasks.CreateSecrets do
  use Mix.Task

  def run(_) do
  #  Mix.Task.run "app.start", []

    IO.puts "Generating secrets file."
    guardian_secret = gen_secret()
    phx_secret = gen_secret()
    IO.puts "Guardian: #{guardian_secret}"
    IO.puts "Phx: #{phx_secret}"

    lines = [
      "use Mix.Config",
      "",
      "config :cip, CipWeb.Endpoint,",
      "  secret_key_base: \"#{phx_secret}\"",
      "",
      "config :cip, Cip.Guardian,",
      "  secret_key: \"#{guardian_secret}\""
    ]

    filename = "./config/cip.secret.exs"

    case File.open filename, [:write] do
      {:ok, file} ->
        IO.binwrite file, Enum.join(lines, "\n")
        File.close file
      {:error, msg } ->
        IO.puts "Error trying to write file #{filename}"
        IO.puts msg
    end
  end

  # stolen from phx.gen.secret & guardian.gen.secret which I suppose copied each other
  defp gen_secret do
    64 |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, 64)
  end
end
