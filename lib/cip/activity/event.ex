defmodule Cip.Activity.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cip.Activity.Event


  schema "events" do
    field :action, :string
    field :target_id, :integer, default: 0
    belongs_to :user, Cip.Users.User

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:action, :target_id, :user_id])
    |> validate_required([:action, :user_id])
  end
end
