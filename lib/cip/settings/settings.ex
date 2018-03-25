defmodule Cip.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias Cip.Repo

  alias Cip.Settings.Option

  @doc """
  Returns the list of options.

  ## Examples

      iex> list_options()
      [%Option{}, ...]

  """
  def list_options do
    Repo.all(Option)
  end

  @doc """
  Gets a single option by name

  Provides a default of 'null' if not found
  or a default if there is an application default

  ## Examples

      iex> get_option!()
      %Option{}

      iex> get_option!(456)
      ** (Ecto.NoResultsError)

  """
  def get_option(name) do
    case Repo.get_by(Option, name: name) do
      nil -> %Option{ name: name, value: default name }
      opt -> opt
    end
  end

  defp default(name) do
    case name do
      "is-site-enabled" -> "false"
      "is-public-access" -> "false"
      "lesson-instructions" -> "<p>Study each of the topics below. There will be a test on the material at the end of the research project.</p>"
      "cip-instructions" -> "<p>Complete the puzzle by clicking within a box to open the answer choices for that column. Then drag the correct answer from the answer choices to the correct box.</p>"
      _ -> "null"
    end
  end

  @doc """
  Creates a option.

  ## Examples

      iex> create_option(%{field: value})
      {:ok, %Option{}}

      iex> create_option(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_option(attrs \\ %{}) do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a option.

  ## Examples

      iex> update_option(option, %{field: new_value})
      {:ok, %Option{}}

      iex> update_option(option, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_option(%Option{} = option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end


  def insert_or_update_option(%Option{} = option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.insert_or_update
  end

  @doc """
  Deletes a Option.

  ## Examples

      iex> delete_option(option)
      {:ok, %Option{}}

      iex> delete_option(option)
      {:error, %Ecto.Changeset{}}

  """
  def delete_option(%Option{} = option) do
    Repo.delete(option)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking option changes.

  ## Examples

      iex> change_option(option)
      %Ecto.Changeset{source: %Option{}}

  """
  def change_option(%Option{} = option) do
    Option.changeset(option, %{})
  end
end
