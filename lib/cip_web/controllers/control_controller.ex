defmodule CipWeb.ControlController do
  use CipWeb, :controller

  import Ecto.Query, warn: false
  alias Cip.Dicts
  alias Cip.Lessons
  alias Cip.Lessons.Lesson
  alias Cip.Activity.Event
  alias Cip.Repo

  # any logged in user can view lessons
  # plug Guardian.Permissions.Bitwise, ensure: %{user: [:control]}

  def index(conn, _params) do
    lessons = Lessons.list_lessons()
    user = Cip.Guardian.Plug.current_resource(conn)
    lessons_meta = Cip.Activity.lessons_meta(user, lessons) 
    instructions = Cip.Settings.get_option("lesson-instructions")
    render(conn, "index.html", lessons: lessons_meta, instructions: instructions.value)
  end

  def show(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)
    dict = Dicts.get_dict()

    # log access
    user = Cip.Guardian.Plug.current_resource(conn)
    user
    |> Ecto.build_assoc(:events, %{action: "access lesson", target_id: lesson.id})
    |> Cip.Repo.insert!

    is_read =
      case Repo.all(from e in Event, where: e.user_id == ^user.id, where:
        e.action == "complete lesson", where: e.target_id == ^lesson.id) do
          [] -> false
          _ -> true
      end

    render(conn, "show.html", lesson: lesson, dict: dict.content, is_read: is_read)
  end

  def mark(conn, %{"id" => id}) do
    lesson = Lessons.get_lesson!(id)

    # log access
    user = Cip.Guardian.Plug.current_resource(conn)
    user
    |> Ecto.build_assoc(:events, %{action: "complete lesson", target_id: lesson.id})
    |> Cip.Repo.insert!

    render(conn, "mark.json")
  end
end
