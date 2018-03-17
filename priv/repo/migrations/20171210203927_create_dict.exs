defmodule Cip.Repo.Migrations.CreateDict do
  use Ecto.Migration

  def change do
    create table(:dict) do
      add :content, :text

      timestamps()
    end

  end
end
