defmodule CipWeb.SessionController do
  use CipWeb, :controller
  alias Cip.Users
  alias Cip.Activity
  alias Cip.Settings

  def create(conn, %{"username" => email, "password" => password}) do
    case Users.find_and_authenticate(email, password) do
      {:ok, user} ->
        perms = Users.permissions(user)
        home_page = Users.home_page(user)
        # log the sign in event
        user
        |> Ecto.build_assoc(:events, %{:action => "sign in"})
        |> Cip.Repo.insert!
        # redirect
        conn
        |> Cip.Guardian.Plug.sign_in(user, %{}, permissions: perms)
        |> put_flash(:info, "Sign in successful")
        |> redirect(to: home_page)
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> Cip.Guardian.Plug.sign_out
    |> put_flash(:info, "Sign out successful")
    |> redirect(to: "/")
  end

  # def unauthenticated(conn, _params) do
  #   conn
  #   |> put_flash(:error, "You must login")
  #   |> redirect(to: "/")
  # end

  # def unauthorized(conn, _params) do
  #   conn
  #   |> put_flash(:error, "You don't have permission to do that.")
  #   |> redirect(to: study_path(conn, :index))
  # end
end
