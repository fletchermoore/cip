defmodule CipWeb.PageController do
  use CipWeb, :controller
  alias Cip.Users

  def index(conn, _params) do
    user = Cip.Guardian.Plug.current_resource(conn)
    if user do
      home_page = Users.home_page(user)
      conn
      |> redirect(to: home_page)
    else
      render conn, "index.html", user: user
    end
  end

  def test(conn, _params) do
    render conn, "test.html"
  end

  def disabled(conn, _params) do
    render conn, "disabled.html"
  end
end
