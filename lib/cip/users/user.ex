defmodule Cip.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cip.Users.User

  @derive {Poison.Encoder, only: [:email, :identifier, :is_admin, :is_control, :is_enabled, :is_invited,
    :is_deleted, :id]}


  schema "users" do
    field :email, :string
    field :identifier, :string, default: ""
    field :is_admin, :boolean, default: false
    field :is_control, :boolean, default: false
    field :is_enabled, :boolean, default: true
    field :is_invited, :boolean, default: false
    field :password_hash, :string
    field :is_deleted, :boolean, default: false
    has_many :events, Cip.Activity.Event

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :is_admin, :is_control, :is_invited, :is_enabled, :identifier, :is_deleted])
    |> validate_required([:email, :password_hash, :is_admin, :is_control])
    |> unique_constraint(:email)
  end
end
