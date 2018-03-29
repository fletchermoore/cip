defmodule CipWeb.Plugs.MaybeRequireLogin do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(default), do: default

  def call(conn, opts) do
    option = Cip.Settings.get_option("is-public-access")
    case option.value do
      "true" -> conn
      "false" -> Guardian.Plug.EnsureAuthenticated.call(conn, opts)
    end
  end
end
