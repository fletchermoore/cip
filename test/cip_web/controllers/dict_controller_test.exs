defmodule CipWeb.DictControllerTest do
  use CipWeb.ConnCase

  alias Cip.Dicts

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:dict) do
    {:ok, dict} = Dicts.create_dict(@create_attrs)
    dict
  end

  describe "index" do
    test "lists all dict", %{conn: conn} do
      conn = get conn, dict_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Dict"
    end
  end

  describe "new dict" do
    test "renders form", %{conn: conn} do
      conn = get conn, dict_path(conn, :new)
      assert html_response(conn, 200) =~ "New Dict"
    end
  end

  describe "create dict" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, dict_path(conn, :create), dict: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == dict_path(conn, :show, id)

      conn = get conn, dict_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Dict"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, dict_path(conn, :create), dict: @invalid_attrs
      assert html_response(conn, 200) =~ "New Dict"
    end
  end

  describe "edit dict" do
    setup [:create_dict]

    test "renders form for editing chosen dict", %{conn: conn, dict: dict} do
      conn = get conn, dict_path(conn, :edit, dict)
      assert html_response(conn, 200) =~ "Edit Dict"
    end
  end

  describe "update dict" do
    setup [:create_dict]

    test "redirects when data is valid", %{conn: conn, dict: dict} do
      conn = put conn, dict_path(conn, :update, dict), dict: @update_attrs
      assert redirected_to(conn) == dict_path(conn, :show, dict)

      conn = get conn, dict_path(conn, :show, dict)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, dict: dict} do
      conn = put conn, dict_path(conn, :update, dict), dict: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Dict"
    end
  end

  describe "delete dict" do
    setup [:create_dict]

    test "deletes chosen dict", %{conn: conn, dict: dict} do
      conn = delete conn, dict_path(conn, :delete, dict)
      assert redirected_to(conn) == dict_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, dict_path(conn, :show, dict)
      end
    end
  end

  defp create_dict(_) do
    dict = fixture(:dict)
    {:ok, dict: dict}
  end
end
