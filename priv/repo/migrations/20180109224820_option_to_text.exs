defmodule Cip.Repo.Migrations.OptionToText do
  use Ecto.Migration

  def change do
    alter table(:options) do
      modify :value, :text
    end
  end
end
