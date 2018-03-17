defmodule CipWeb.AdminController do
  use CipWeb, :controller
  
  plug Guardian.Permissions.Bitwise, ensure: %{user: [:admin]}

  def index(conn, _params) do
    user = Cip.Guardian.Plug.current_resource(conn)
    render conn, "index.html", user: user
  end
end
