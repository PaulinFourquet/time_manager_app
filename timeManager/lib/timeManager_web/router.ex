defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :put_root_layout, html: {TimeManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline, module: TimeManager.Guardian,
      error_handler: TimeManagerWeb.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Routes pour les utilisateurs (Users)
    get "/users", UserController, :index # GET pour lister les utilisateurs
    get "/users/:id", UserController, :show # GET pour récupérer un utilisateur
    post "/users", UserController, :create # POST pour créer un utilisateur
    put "/users/:id", UserController, :update # PUT pour mettre à jour un utilisateur
    delete "/users/:id", UserController, :delete # DELETE pour supprimer un utilisateur

    # Routes pour l'authentification (Auth)
    post "/login", AuthController, :login
    post "/logout", AuthController, :logout

    # Routes protégées
    resources "/users", UserController, except: [:new, :edit]

    # Routes pour les temps de travail (workingtime)
    get "/workingtime", WorkingTimeController,  :index # GET pour lister tous les temps de travail
    get "/workingtime/:user_id", WorkingTimeController, :listByUserId # GET pour lister les temps de travail
    get "/workingtime/:user_id/:id", WorkingTimeController, :show # GET pour récupérer un temps de travail
    post "/workingtime/:user_id", WorkingTimeController, :create # POST pour créer un temps de travail
    put "/workingtime/:id", WorkingTimeController, :update # PUT pour mettre à jour un temps de travail
    delete "/workingtime/:id", WorkingTimeController, :delete # DELETE pour supprimer un temps de travail

    # Routes pour les horloges (Clocks)
    get "/clocks/:user_id", ClockController, :show # GET pour récupérer une horloge
    post "/clocks/:user_id", ClockController, :create # Post pour crée une horloge

    # Routes pour les rôles (Roles)
    resources "/role", RoleController, except: [:new, :edit]
    post "/user_roles/:user_id/:role_id", UserRoleController, :assign_role
    get "/user_roles/:user_id", UserRoleController, :get_user_roles
    put "/user_roles/:user_id/:old_role_id/:new_role_id", UserRoleController, :update_user_role
    delete "/user_roles/:user_id/:role_id", UserRoleController, :remove_user_role
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timeManager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
