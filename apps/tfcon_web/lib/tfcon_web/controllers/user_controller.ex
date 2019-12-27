defmodule TfconWeb.UserController do
  use TfconWeb, :controller

  alias Tfcon.Accounts

  def index(conn, _) do
    render(conn, "index.json", %{users: Accounts.list_users()})
  end

  def show(conn, %{"account_number" => account_number}) do
    {account_number, ""} = Integer.parse(account_number)
    account = Accounts.get_user_by_account_number!(account_number)

    render(conn, "show.json", account)
  end
end
