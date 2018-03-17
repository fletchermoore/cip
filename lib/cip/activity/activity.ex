defmodule Cip.Activity do
  @moduledoc """
  The Activity context.
  """

  import Ecto.Query, warn: false
  alias Cip.Repo

  alias Cip.Activity.Event

  def puzzle_meta(user, puzzles) do
    events = Repo.all(from e in Event, where: e.user_id == ^user.id, where: e.action == "complete cip")
    Enum.map(puzzles, fn(p) -> %{puzzle: p, is_complete: find_match(p, events)} end)
  end

  # shouldn't copy paste so much, but we're almost done with this thing.
  def lessons_meta(user, puzzles) do
    events = Repo.all(from e in Event, where: e.user_id == ^user.id, where: e.action == "complete lesson")
    Enum.map(puzzles, fn(p) -> %{lesson: p, is_complete: find_match(p, events)} end)
  end

  defp find_match(puzzle, events) do
    case Enum.find(events, fn(e) -> e.target_id == puzzle.id end) do
      nil -> false
      _ -> true
    end
  end

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event) |> Repo.preload(:user)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end
end
