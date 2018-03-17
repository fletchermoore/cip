defmodule CipWeb.DictController do
  use CipWeb, :controller

  alias Cip.Dicts
  alias Cip.Dicts.Dict

  plug Guardian.Permissions.Bitwise, ensure: %{user: [:admin]}

  def index(conn, _params) do
    dict = Dicts.get_dict()
    render(conn, "index.html", dict: dict.content)
  end

  def new(conn, _params) do
    changeset = Dicts.change_dict(%Dict{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"dict" => dict_params}) do
    case Dicts.create_dict(dict_params) do
      {:ok, dict} ->
        conn
        |> put_flash(:info, "Dict created successfully.")
        |> redirect(to: dict_path(conn, :show, dict))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dict = Dicts.get_dict!(id)
    render(conn, "show.html", dict: dict)
  end

  def edit(conn, %{"id" => id}) do
    dict = Dicts.get_dict!(id)
    changeset = Dicts.change_dict(dict)
    render(conn, "edit.html", dict: dict, changeset: changeset)
  end

  # called by save on edit page (hidden by default but not removed)
  def update(conn, %{"id" => id, "dict" => dict_params}) do
    dict = Dicts.get_dict!(id)

    case Dicts.update_dict(dict, dict_params) do
      {:ok, dict} ->
        conn
        |> put_flash(:info, "Dict updated successfully.")
        |> redirect(to: dict_path(conn, :show, dict))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", dict: dict, changeset: changeset)
    end
  end

  # called by save on index page
  def update_dict(conn, %{"dict" => dict_params}) do
    dict = Dicts.get_dict()

    if dict == nil do # initial dict was not created for some reason
      conn
      |> put_flash(:error, "Something went wrong. Please contact system administrator.")
      |> redirect(to: dict_path(conn, :index))
    else
      case Dicts.update_dict(dict, dict_params) do
        {:ok, dict} ->
          conn
          |> put_flash(:info, "Dictionary updated successfully.")
          |> redirect(to: dict_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:error, "Something went wrong. Please contact system administrator.")
          |> redirect(to: dict_path(conn, :index))
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    dict = Dicts.get_dict!(id)
    {:ok, _dict} = Dicts.delete_dict(dict)

    conn
    |> put_flash(:info, "Dict deleted successfully.")
    |> redirect(to: dict_path(conn, :index))
  end
end
