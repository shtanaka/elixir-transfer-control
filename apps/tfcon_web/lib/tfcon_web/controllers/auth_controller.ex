defmodule TfconWeb.AuthController do
  use TfconWeb, :controller

  alias Tfcon.{Accounts, Guardian}
  alias Tfcon.JsonHandler

  def create(conn, %{"account_number" => account_number, "password" => password}) do
    auth_data = Accounts.authenticate_user(account_number, password)
    login_reply(conn, auth_data)
  end

  defp login_reply(conn, {:ok, user}) do
    {:ok, token, _} = Guardian.encode_and_sign(user)
    json(conn, JsonHandler.success_json(%{token: token}))
  end
  defp login_reply(conn, {:error, reason}) do
    conn
    |> put_status(401)
    |> json(JsonHandler.error_json(%{errors: [reason]}))
  end
end
