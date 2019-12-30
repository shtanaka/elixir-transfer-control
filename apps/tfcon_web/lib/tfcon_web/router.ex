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

    get "/day_report", ReportController, :day_report
    get "/month_report", ReportController, :month_report
    get "/year_report", ReportController, :year_report
    get "/all_time_report", ReportController, :all_time_report
  end

  scope "/api/v1", TfconWeb do
    pipe_through :api

    post "/auth", AuthController, :create
  end

  scope "/api/v1/users", TfconWeb do
    pipe_through :api

    resources "/", UserController, param: "account_number", only: [:create]

    pipe_through :ensure_auth

    resources "/", UserController, param: "account_number", except: [:create]
  end

  scope "/api/v1/bank", TfconWeb do
    pipe_through :api
    pipe_through :ensure_auth

    get "/my_account", BankController, :my_account
    post "/transfer", BankController, :transfer
  end
end
