defmodule Cip.SettingsTest do
  use Cip.DataCase

  alias Cip.Settings

  describe "options" do
    alias Cip.Settings.Option

    @valid_attrs %{name: "some name", value: "some value"}
    @update_attrs %{name: "some updated name", value: "some updated value"}
    @invalid_attrs %{name: nil, value: nil}

    def option_fixture(attrs \\ %{}) do
      {:ok, option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_option()

      option
    end

    test "list_options/0 returns all options" do
      option = option_fixture()
      assert Settings.list_options() == [option]
    end

    test "get_option!/1 returns the option with given id" do
      option = option_fixture()
      assert Settings.get_option!(option.id) == option
    end

    test "create_option/1 with valid data creates a option" do
      assert {:ok, %Option{} = option} = Settings.create_option(@valid_attrs)
      assert option.name == "some name"
      assert option.value == "some value"
    end

    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_option(@invalid_attrs)
    end

    test "update_option/2 with valid data updates the option" do
      option = option_fixture()
      assert {:ok, option} = Settings.update_option(option, @update_attrs)
      assert %Option{} = option
      assert option.name == "some updated name"
      assert option.value == "some updated value"
    end

    test "update_option/2 with invalid data returns error changeset" do
      option = option_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_option(option, @invalid_attrs)
      assert option == Settings.get_option!(option.id)
    end

    test "delete_option/1 deletes the option" do
      option = option_fixture()
      assert {:ok, %Option{}} = Settings.delete_option(option)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_option!(option.id) end
    end

    test "change_option/1 returns a option changeset" do
      option = option_fixture()
      assert %Ecto.Changeset{} = Settings.change_option(option)
    end
  end
end
