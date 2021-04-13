defmodule LiveviewTrelloWeb.Router do
  use LiveviewTrelloWeb, :router

  pipeline :auth do
    plug LiveviewTrello.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :redirect_check do
    plug LiveviewTrelloWeb.Plugs.Redirector
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveviewTrelloWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveviewTrelloWeb do
    pipe_through [:browser, :auth, :redirect_check]
    get "/sign_in", AuthController, :index
    post "/sign_in", AuthController, :login
    live "/sign_up", SignUp
  end

  scope "/", LiveviewTrelloWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/logout", AuthController, :logout
    live "/", Home
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveviewTrelloWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LiveviewTrelloWeb.Telemetry
    end
  end
end
