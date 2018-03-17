defmodule Cip.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :is_admin, :boolean, default: false, null: false
      add :is_control, :boolean, default: false, null: false
      add :identifier, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
