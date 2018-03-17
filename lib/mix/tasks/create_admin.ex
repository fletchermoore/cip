defmodule Mix.Tasks.CreateAdmin do
  use Mix.Task

  def run(_) do
    Mix.Task.run "app.start", []

    name = IO.gets("Enter an admin username: ") |> String.trim
    pw = IO.gets("Enter an admin password: ") |> String.trim

    Cip.Users.create_user %{
      "email" => name,
      "password_hash" => pw,
      "is_admin" => true}

    IO.puts("Admin '#{name}' created with password '#{pw}'.")
  end
end
