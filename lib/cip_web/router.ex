defmodule CipWeb.Router do
  use CipWeb, :router

  pipeline :browser_auth do
    plug Guardian.Plug.Pipeline, module: Cip.Guardian,
                                 error_handler: Cip.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :admin_auth do
    plug Guardian.Permissions.Bitwise, ensure: %{user: [:admin]}
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :ensure_enabled do
    plug CipWeb.Plugs.EnsureEnabled
  end

  pipeline :maybe_require_login do
    plug CipWeb.Plugs.MaybeRequireLogin
  end

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", CipWeb do # does not require login
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index
    get "/login", PageController, :login
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    post "/reset", UserController, :reset_pw
  end

  # these routes check if login is required and if the site is enabled
  scope "/", CipWeb do # require a log in of some sort
    pipe_through [:browser, :browser_auth, :maybe_require_login, :ensure_enabled]

    get "/cips", ExpController, :index # requires exp permission
    get "/cips/:id", ExpController, :show
    get "/topics", ControlController, :index # requires control permission
    get "/topics/:id", ControlController, :show

    post "/exp/:id/mark", ExpController, :mark # ajax call on puzzle completion
    post "/control/:id/mark", ControlController, :mark # mark as read
  end

  # requires login, but can do while site is disabled
  scope "/", CipWeb do
    pipe_through [:browser, :browser_auth, :require_login]
    get "/disabled", PageController, :disabled
    get "/settings", UserController, :settings
    put "/settings", UserController, :update_settings
  end

  scope "/", CipWeb do # require admin
    pipe_through [:browser, :browser_auth, :admin_auth]
    resources "/users", UserController
    post "/users/:id", UserController, :invite

    get "/admin", AdminController, :index
    get "/test", PageController, :test
    resources "/puzzles", PuzzleController
    resources "/lessons", LessonController
    put "/dict/update", DictController, :update_dict
    resources "/dict", DictController

    resources "/options", OptionController, except: [:new, :edit]

    get "/log", ActivityController, :index
  end
end
