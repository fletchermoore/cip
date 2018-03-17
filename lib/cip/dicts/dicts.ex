defmodule Cip.Dicts do
  @moduledoc """
  The Dicts context.
  """

  import Ecto.Query, warn: false
  alias Cip.Repo

  alias Cip.Dicts.Dict

  @doc """
  Returns the list of dict.

  ## Examples

      iex> list_dict()
      [%Dict{}, ...]

  """
  def list_dict do
    Repo.all(Dict)
  end

  def get_dict do
    case Repo.one(from d in Dict, limit: 1) do
      nil ->
        case create_dict(%{content: "{}"}) do
          {:ok, dict} -> dict
          {:error, changeset} -> nil
        end
      dict -> dict
    end
  end

  @doc """
  Gets a single dict.

  Raises `Ecto.NoResultsError` if the Dict does not exist.

  ## Examples

      iex> get_dict!(123)
      %Dict{}

      iex> get_dict!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dict!(id), do: Repo.get!(Dict, id)

  @doc """
  Creates a dict.

  ## Examples

      iex> create_dict(%{field: value})
      {:ok, %Dict{}}

      iex> create_dict(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dict(attrs \\ %{}) do
    %Dict{}
    |> Dict.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dict.

  ## Examples

      iex> update_dict(dict, %{field: new_value})
      {:ok, %Dict{}}

      iex> update_dict(dict, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dict(%Dict{} = dict, attrs) do
    dict
    |> Dict.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Dict.

  ## Examples

      iex> delete_dict(dict)
      {:ok, %Dict{}}

      iex> delete_dict(dict)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dict(%Dict{} = dict) do
    Repo.delete(dict)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dict changes.

  ## Examples

      iex> change_dict(dict)
      %Ecto.Changeset{source: %Dict{}}

  """
  def change_dict(%Dict{} = dict) do
    Dict.changeset(dict, %{})
  end
end
