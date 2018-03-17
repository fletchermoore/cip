defmodule Cip.Dicts.Dict do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cip.Dicts.Dict

  schema "dict" do
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(%Dict{} = dict, attrs) do
    dict
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
