defmodule CipWeb.PuzzleController do
  use CipWeb, :controller

  alias Cip.Puzzles
  alias Cip.Puzzles.Puzzle
  alias Cip.Dicts

  plug Guardian.Permissions.Bitwise, ensure: %{user: [:admin]}

  def index(conn, _params) do
    puzzles = Puzzles.list_puzzles()
    render(conn, "index.html", puzzles: puzzles)
  end

  def new(conn, _params) do
    changeset = Puzzles.change_puzzle(%Puzzle{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"puzzle" => puzzle_params}) do
    case Puzzles.create_puzzle(puzzle_params) do
      {:ok, puzzle} ->
        conn
        |> put_flash(:info, "Puzzle created successfully.")
        |> redirect(to: puzzle_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    puzzle = Puzzles.get_puzzle!(id)
    dict = Dicts.get_dict()
    render(conn, "show.html", puzzle: puzzle, dict: dict.content)
  end

  def edit(conn, %{"id" => id}) do
    puzzle = Puzzles.get_puzzle!(id)
    changeset = Puzzles.change_puzzle(puzzle)
    render(conn, "edit.html", puzzle: puzzle, changeset: changeset)
  end

  def update(conn, %{"id" => id, "puzzle" => puzzle_params}) do
    puzzle = Puzzles.get_puzzle!(id)

    case Puzzles.update_puzzle(puzzle, puzzle_params) do
      {:ok, puzzle} ->
        conn
        |> put_flash(:info, "Puzzle updated successfully.")
        |> redirect(to: puzzle_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", puzzle: puzzle, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    puzzle = Puzzles.get_puzzle!(id)
    {:ok, _puzzle} = Puzzles.delete_puzzle(puzzle)

    conn
    |> put_flash(:info, "Puzzle deleted successfully.")
    |> redirect(to: puzzle_path(conn, :index))
  end
end
