defmodule Cip.Repo.Migrations.CreatePuzzles do
  use Ecto.Migration

  def change do
    create table(:puzzles) do
      add :title, :string
      add :content, :text

      timestamps()
    end

  end
end
