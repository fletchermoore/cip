defmodule CipWeb.ActivityController do
  use CipWeb, :controller

  alias Cip.Activity

  plug Guardian.Permissions.Bitwise, ensure: %{user: [:admin]}

  def index(conn, _params) do
    # user = Cip.Guardian.Plug.current_resource(conn)
    events = Activity.list_events
    render conn, "index.html", events: events
  end
end
