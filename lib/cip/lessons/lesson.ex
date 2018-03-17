defmodule Cip.Lessons.Lesson do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cip.Lessons.Lesson


  schema "lessons" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Lesson{} = lesson, attrs) do
    lesson
    |> cast(attrs, [:title, :content])
    |> validate_required([:title])
  end
end
