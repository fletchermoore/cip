defmodule Cip.PuzzlesTest do
  use Cip.DataCase

  alias Cip.Puzzles

  describe "puzzles" do
    alias Cip.Puzzles.Puzzle

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def puzzle_fixture(attrs \\ %{}) do
      {:ok, puzzle} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Puzzles.create_puzzle()

      puzzle
    end

    test "list_puzzles/0 returns all puzzles" do
      puzzle = puzzle_fixture()
      assert Puzzles.list_puzzles() == [puzzle]
    end

    test "get_puzzle!/1 returns the puzzle with given id" do
      puzzle = puzzle_fixture()
      assert Puzzles.get_puzzle!(puzzle.id) == puzzle
    end

    test "create_puzzle/1 with valid data creates a puzzle" do
      assert {:ok, %Puzzle{} = puzzle} = Puzzles.create_puzzle(@valid_attrs)
      assert puzzle.content == "some content"
      assert puzzle.title == "some title"
    end

    test "create_puzzle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Puzzles.create_puzzle(@invalid_attrs)
    end

    test "update_puzzle/2 with valid data updates the puzzle" do
      puzzle = puzzle_fixture()
      assert {:ok, puzzle} = Puzzles.update_puzzle(puzzle, @update_attrs)
      assert %Puzzle{} = puzzle
      assert puzzle.content == "some updated content"
      assert puzzle.title == "some updated title"
    end

    test "update_puzzle/2 with invalid data returns error changeset" do
      puzzle = puzzle_fixture()
      assert {:error, %Ecto.Changeset{}} = Puzzles.update_puzzle(puzzle, @invalid_attrs)
      assert puzzle == Puzzles.get_puzzle!(puzzle.id)
    end

    test "delete_puzzle/1 deletes the puzzle" do
      puzzle = puzzle_fixture()
      assert {:ok, %Puzzle{}} = Puzzles.delete_puzzle(puzzle)
      assert_raise Ecto.NoResultsError, fn -> Puzzles.get_puzzle!(puzzle.id) end
    end

    test "change_puzzle/1 returns a puzzle changeset" do
      puzzle = puzzle_fixture()
      assert %Ecto.Changeset{} = Puzzles.change_puzzle(puzzle)
    end
  end
end
