defmodule Cip.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Cip.Repo
  alias Cip.Users.User

  def find_and_authenticate(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, "Incorrect username or password"}
      user ->
        if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
          if (user.is_deleted) do
            {:error, "That account is disabled."}
          else
            {:ok, user}
          end
        else
          {:error, "Incorrect username or password"}
        end
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(from u in User, order_by: u.email)
  end

  def user_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email, limit: 1)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    attrs =
      case attrs["password_hash"] do
        nil ->
          Map.put(attrs, "password_hash", Comeonin.Bcrypt.hashpwsalt("abc123"))
        unencrypted_pw ->
          %{attrs | "password_hash" => Comeonin.Bcrypt.hashpwsalt(unencrypted_pw)}
      end
    changeset = User.changeset(%User{}, attrs)
    Repo.insert(changeset)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    encrypted_password = Comeonin.Bcrypt.hashpwsalt(attrs["password_hash"])
    User.changeset(user, attrs)
    |> put_change(:password_hash, encrypted_password)
    |> Repo.update()
  end

  @doc """
  Updates a user without requiring a password field, the typical use case
  """
  def update_user_wo_password(%User{} = user, attrs) do
    User.changeset(user, attrs)
    |> Repo.update()
  end

  @doc """
  Updates flag to say users is deleted

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    User.changeset(user, %{"is_deleted" => true})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def permissions(user) do
    if user.is_admin do
      %{user: [:admin, :control, :exp]} # admin can access any page
    else
      if user.is_control do
        %{user: [:control]}
      else
        %{user: [:exp]}
      end
    end
  end

  def home_page(user) do
    if user.is_admin do
      "/admin"
    else
      if user.is_control do
        "/topics"
      else
        "/cips"
      end
    end
  end
end
