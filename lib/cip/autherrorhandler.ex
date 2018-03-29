defmodule Cip.AuthErrorHandler do
  import Plug.Conn
  use CipWeb, :controller

  def auth_error(conn, {type, reason}, _opts) do
    # body = Poison.encode!(%{message: to_string(type)})
    conn
    |> put_flash(:error, "You must be logged in to access this part of the website.")
    |> redirect(to: "/login")
  end
end
