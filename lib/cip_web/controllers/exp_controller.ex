defmodule CipWeb.ExpController do
  use CipWeb, :controller

  alias Cip.Dicts
  alias Cip.Puzzles
  alias Cip.Puzzles.Puzzle

  plug Guardian.Permissions.Bitwise, ensure: %{user: [:exp]}

  def index(conn, _params) do
    puzzles = Puzzles.list_puzzles()
    lessons = Cip.Lessons.list_lessons()
    user = Cip.Guardian.Plug.current_resource(conn)
    puzzle_meta = Cip.Activity.puzzle_meta(user, puzzles)
    instructions = Cip.Settings.get_option("cip-instructions")
    render(conn, "index.html", puzzles_meta: puzzle_meta, lessons: lessons, instructions: instructions.value)
  end

  def show(conn, %{"id" => id}) do
    puzzle = Puzzles.get_puzzle!(id)
    dict = Dicts.get_dict()

    # log access
    user = Cip.Guardian.Plug.current_resource(conn)
    user
    |> Ecto.build_assoc(:events, %{action: "access cip", target_id: puzzle.id})
    |> Cip.Repo.insert!

    render(conn, "show.html", puzzle: puzzle, dict: dict.content)
  end

  def mark(conn, %{"id" => id}) do
    puzzle = Puzzles.get_puzzle!(id)

    # log access
    user = Cip.Guardian.Plug.current_resource(conn)
    user
    |> Ecto.build_assoc(:events, %{action: "complete cip", target_id: puzzle.id})
    |> Cip.Repo.insert!

    render(conn, "mark.json")
  end
end
