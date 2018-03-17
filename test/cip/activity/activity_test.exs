defmodule Cip.ActivityTest do
  use Cip.DataCase

  alias Cip.Activity

  describe "events" do
    alias Cip.Activity.Event

    @valid_attrs %{action: "some action", target_id: 42}
    @update_attrs %{action: "some updated action", target_id: 43}
    @invalid_attrs %{action: nil, target_id: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activity.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Activity.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Activity.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Activity.create_event(@valid_attrs)
      assert event.action == "some action"
      assert event.target_id == 42
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activity.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Activity.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.action == "some updated action"
      assert event.target_id == 43
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Activity.update_event(event, @invalid_attrs)
      assert event == Activity.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Activity.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Activity.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Activity.change_event(event)
    end
  end
end
