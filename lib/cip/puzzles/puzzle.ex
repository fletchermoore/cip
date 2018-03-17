defmodule Cip.Puzzles.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cip.Puzzles.Puzzle


  schema "puzzles" do
    field :content, :string
    field :title, :string
    field :row_count, :integer, default: 4

    timestamps()
  end

  @doc false
  def changeset(%Puzzle{} = puzzle, attrs) do
    puzzle
    |> cast(attrs, [:title, :content, :row_count])
    |> validate_required([:title, :content])
  end
end
