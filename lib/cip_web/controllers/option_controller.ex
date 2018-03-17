defmodule CipWeb.OptionController do
  use CipWeb, :controller

  alias Cip.Settings
  alias Cip.Settings.Option

  action_fallback CipWeb.FallbackController

  def index(conn, _params) do
    options = Settings.list_options()
    render(conn, "index.json", options: options)
  end

  def create(conn, %{"option" => option_params}) do
    with {:ok, %Option{} = option} <- Settings.create_option(option_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", option_path(conn, :show, option))
      |> render("show.json", option: option)
    end
  end

  # the default route creator uses the symbol id, but we will be using name strings
  def show(conn, %{"id" => id}) do
    option = Settings.get_option(id)
    render(conn, "show.json", option: option)
  end


  # insert or update
  def update(conn, %{"id" => id, "value" => value}) do
    option = Settings.get_option(id)

    with {:ok, %Option{} = option} <- Settings.insert_or_update_option(option, %{ "value" => value }) do
      render(conn, "show.json", option: option)
    end
  end

  def delete(conn, %{"id" => id}) do
    option = Settings.get_option(id)
    with {:ok, %Option{}} <- Settings.delete_option(option) do
      send_resp(conn, :no_content, "")
    end
  end
end
