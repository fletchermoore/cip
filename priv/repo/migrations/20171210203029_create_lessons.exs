defmodule Cip.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :title, :string
      add :content, :text

      timestamps()
    end

  end
end
