defmodule CipWeb.UserView do
  use CipWeb, :view

  def render "invite.json", _nothing do
    %{ok: "invite sent"}
  end

  def render "error.json", _nothing do
    %{error: "error"}
  end

  def render "delete.json", _nada do
    %{ok: "deleted"}
  end
end
