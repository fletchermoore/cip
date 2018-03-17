defmodule Cip.Settings.Option do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cip.Settings.Option


  schema "options" do
    field :name, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(%Option{} = option, attrs) do
    option
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
