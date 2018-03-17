defmodule CipWeb.ExpView do
  use CipWeb, :view

  def render "mark.json", _nothing do
    %{ok: "marked"}
  end
end
