defmodule Cip.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_enabled, :boolean, default: true
      add :is_invited, :boolean, default: false
    end
  end
end
