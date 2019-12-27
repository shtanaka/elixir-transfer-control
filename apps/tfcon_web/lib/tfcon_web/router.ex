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
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", TfconWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", TfconWeb do
    post "/auth", AuthController, :create

    pipe_through :api
    # resources "/users", UserController
  end
end
