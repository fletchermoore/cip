defmodule CipWeb.UserController do
  use CipWeb, :controller

  alias Cip.Users
  alias Cip.Users.User
  alias Cip.Mail.Email
  alias Cip.Mail.Mailer

  # default routes, which require admin auth to access
  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users, user_json: Poison.encode!(users))
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.email} created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "That email address already exists. It may be a deleted user.")
        |> redirect(to: user_path(conn, :index))
    end
  end

  def invite(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    temp_pw = Cip.PasswordGenerator.random(6)
    case Users.update_user(user, %{"password_hash" => temp_pw, "is_invited" => true}) do
      {:ok, user} ->
        Email.invite_email(conn, user, temp_pw) |> Mailer.deliver_now
        render conn, "invite.json"
      {:error, _} ->
        render conn, "error.json"
    end
  end

  def reset_pw(conn, %{"email" => email}) do
    case Users.user_by_email(email) do
      nil ->
        render conn, "error.json"
      user ->
        temp_pw = Cip.PasswordGenerator.random(6)
        case Users.update_user(user, %{"password_hash" => temp_pw}) do
          {:ok, user} ->
            Email.reset_pw(conn, user, temp_pw) |> Mailer.deliver_now
            render conn, "invite.json"
          {:error, _} ->
            render conn, "error.json"
        end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user_wo_password(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.email} updated successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Error attempting to update user #{user.email}. Check to ensure email is not already taken.")
        |> redirect(to: user_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    # log that admin deleted user
    admin = Cip.Guardian.Plug.current_resource(conn)
    |> Ecto.build_assoc(:events, %{:action => "delete user", :target_id => user.id})
    |> Cip.Repo.insert!

    render conn, "delete.json"
  end

  # does not require admin auth, in router
  def settings(conn, _params) do
    render(conn, "settings.html")
  end

  def update_settings(conn, %{"old" => old, "new" => new, "validate" => validate}) do
    user = Cip.Guardian.Plug.current_resource(conn)
    case Users.find_and_authenticate(user.email, old) do
      {:ok, user} ->
        if new != validate do
          conn
          |> put_flash(:error, "New passwords do not match")
          |> redirect(to: user_path(conn, :settings))
        else
          min_length = 6
          if String.length(new) < min_length do
            conn
            |> put_flash(:error, "Password must be at least #{min_length} characters long.")
            |> redirect(to: user_path(conn, :settings))
          else
            user_params = %{"password_hash" => new}
            case Users.update_user(user, user_params) do
              {:ok, user} ->
                conn
                |> put_flash(:info, "Password updated successfully.")
                |> redirect(to: user_path(conn, :settings))
              {:error, %Ecto.Changeset{} = changeset} ->
                conn
                |> put_flash(:error, "Something went wrong while trying to update the password. Please contact the system administrator.")
                |> redirect(to: user_path(conn, :settings))
            end
          end
        end
      {:error} ->
        conn
        |> put_flash(:error, "Incorrect current password")
        |> redirect(to: user_path(conn, :settings))
    end
  end
end
