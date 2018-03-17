defmodule Cip.Repo.Migrations.AddRowCount do
  use Ecto.Migration

  def change do
    alter table(:puzzles) do
      add :row_count, :integer, default: 4
    end
  end
end
