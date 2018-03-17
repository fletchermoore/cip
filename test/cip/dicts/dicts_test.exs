defmodule Cip.DictsTest do
  use Cip.DataCase

  alias Cip.Dicts

  describe "dict" do
    alias Cip.Dicts.Dict

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def dict_fixture(attrs \\ %{}) do
      {:ok, dict} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dicts.create_dict()

      dict
    end

    test "list_dict/0 returns all dict" do
      dict = dict_fixture()
      assert Dicts.list_dict() == [dict]
    end

    test "get_dict!/1 returns the dict with given id" do
      dict = dict_fixture()
      assert Dicts.get_dict!(dict.id) == dict
    end

    test "create_dict/1 with valid data creates a dict" do
      assert {:ok, %Dict{} = dict} = Dicts.create_dict(@valid_attrs)
      assert dict.content == "some content"
    end

    test "create_dict/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dicts.create_dict(@invalid_attrs)
    end

    test "update_dict/2 with valid data updates the dict" do
      dict = dict_fixture()
      assert {:ok, dict} = Dicts.update_dict(dict, @update_attrs)
      assert %Dict{} = dict
      assert dict.content == "some updated content"
    end

    test "update_dict/2 with invalid data returns error changeset" do
      dict = dict_fixture()
      assert {:error, %Ecto.Changeset{}} = Dicts.update_dict(dict, @invalid_attrs)
      assert dict == Dicts.get_dict!(dict.id)
    end

    test "delete_dict/1 deletes the dict" do
      dict = dict_fixture()
      assert {:ok, %Dict{}} = Dicts.delete_dict(dict)
      assert_raise Ecto.NoResultsError, fn -> Dicts.get_dict!(dict.id) end
    end

    test "change_dict/1 returns a dict changeset" do
      dict = dict_fixture()
      assert %Ecto.Changeset{} = Dicts.change_dict(dict)
    end
  end
end
