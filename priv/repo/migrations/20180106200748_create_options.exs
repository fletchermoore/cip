defmodule Cip.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :name, :string
      add :value, :string

      timestamps()
    end

  end
end
