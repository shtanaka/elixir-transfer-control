defmodule TfconWeb.UserController do
  use TfconWeb, :controller

  alias Tfcon.{Accounts, Guardian}

  def index(conn, _) do
    render(conn, "index.json", %{users: Accounts.list_users()})
  end

  def show(conn, %{"account_number" => account_number}) do
    {account_number, _} = Integer.parse(account_number)
    user = Accounts.get_user_by_account_number!(account_number)

    render_show(conn, user)
  end

  defp render_show(conn, nil), do: conn |> put_status(404) |> render("404.json", %{user: nil})
  defp render_show(conn, user), do: conn |> render("show.json", %{user: user})

  def create(conn, %{"name" => name, "password" => password}) do
    create_data = Accounts.create_user(%{name: name, password: password})

    render_create(conn, create_data)
  end

  defp render_create(conn, {:ok, user}) do
    {:ok, token, _} = Guardian.encode_and_sign(user)
    conn |> render("create.json", %{user: user, token: token})
  end
  defp render_create(conn, {:error, changeset}),
    do: conn |> put_status(400) |> render("400.json", %{changeset: changeset})
end
