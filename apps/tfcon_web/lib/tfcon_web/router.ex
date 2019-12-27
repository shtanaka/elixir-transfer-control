defmodule TfconWeb.Router do
  use TfconWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Tfcon.Guardian.Pipeline
  end

  pipeline :ensure_auth do
    plug Tfcon.Guardian.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", TfconWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", TfconWeb do
    post "/auth", AuthController, :create

    pipe_through :ensure_auth
    resources "/users", UserController, param: "account_number"
  end
end
