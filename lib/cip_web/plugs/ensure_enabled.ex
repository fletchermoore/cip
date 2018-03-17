defmodule CipWeb.Plugs.EnsureEnabled do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(default), do: default

  def call(conn, _params) do
    option = Cip.Settings.get_option("is-site-enabled")
    case option.value do
      "true" -> conn
      "false" -> conn |> redirect(to: "/disabled") |> halt
    end
  end
end
