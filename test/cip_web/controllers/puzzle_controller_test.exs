defmodule CipWeb.PuzzleControllerTest do
  use CipWeb.ConnCase

  alias Cip.Puzzles

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  def fixture(:puzzle) do
    {:ok, puzzle} = Puzzles.create_puzzle(@create_attrs)
    puzzle
  end

  describe "index" do
    test "lists all puzzles", %{conn: conn} do
      conn = get conn, puzzle_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Puzzles"
    end
  end

  describe "new puzzle" do
    test "renders form", %{conn: conn} do
      conn = get conn, puzzle_path(conn, :new)
      assert html_response(conn, 200) =~ "New Puzzle"
    end
  end

  describe "create puzzle" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, puzzle_path(conn, :create), puzzle: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == puzzle_path(conn, :show, id)

      conn = get conn, puzzle_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Puzzle"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, puzzle_path(conn, :create), puzzle: @invalid_attrs
      assert html_response(conn, 200) =~ "New Puzzle"
    end
  end

  describe "edit puzzle" do
    setup [:create_puzzle]

    test "renders form for editing chosen puzzle", %{conn: conn, puzzle: puzzle} do
      conn = get conn, puzzle_path(conn, :edit, puzzle)
      assert html_response(conn, 200) =~ "Edit Puzzle"
    end
  end

  describe "update puzzle" do
    setup [:create_puzzle]

    test "redirects when data is valid", %{conn: conn, puzzle: puzzle} do
      conn = put conn, puzzle_path(conn, :update, puzzle), puzzle: @update_attrs
      assert redirected_to(conn) == puzzle_path(conn, :show, puzzle)

      conn = get conn, puzzle_path(conn, :show, puzzle)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, puzzle: puzzle} do
      conn = put conn, puzzle_path(conn, :update, puzzle), puzzle: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Puzzle"
    end
  end

  describe "delete puzzle" do
    setup [:create_puzzle]

    test "deletes chosen puzzle", %{conn: conn, puzzle: puzzle} do
      conn = delete conn, puzzle_path(conn, :delete, puzzle)
      assert redirected_to(conn) == puzzle_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, puzzle_path(conn, :show, puzzle)
      end
    end
  end

  defp create_puzzle(_) do
    puzzle = fixture(:puzzle)
    {:ok, puzzle: puzzle}
  end
end
