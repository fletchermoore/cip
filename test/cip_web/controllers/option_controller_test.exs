defmodule CipWeb.OptionControllerTest do
  use CipWeb.ConnCase

  alias Cip.Settings
  alias Cip.Settings.Option

  @create_attrs %{name: "some name", value: "some value"}
  @update_attrs %{name: "some updated name", value: "some updated value"}
  @invalid_attrs %{name: nil, value: nil}

  def fixture(:option) do
    {:ok, option} = Settings.create_option(@create_attrs)
    option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all options", %{conn: conn} do
      conn = get conn, option_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create option" do
    test "renders option when data is valid", %{conn: conn} do
      conn = post conn, option_path(conn, :create), option: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, option_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "value" => "some value"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, option_path(conn, :create), option: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update option" do
    setup [:create_option]

    test "renders option when data is valid", %{conn: conn, option: %Option{id: id} = option} do
      conn = put conn, option_path(conn, :update, option), option: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, option_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "value" => "some updated value"}
    end

    test "renders errors when data is invalid", %{conn: conn, option: option} do
      conn = put conn, option_path(conn, :update, option), option: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete option" do
    setup [:create_option]

    test "deletes chosen option", %{conn: conn, option: option} do
      conn = delete conn, option_path(conn, :delete, option)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, option_path(conn, :show, option)
      end
    end
  end

  defp create_option(_) do
    option = fixture(:option)
    {:ok, option: option}
  end
end
