defmodule TfconWeb.AuthController do
  use TfconWeb, :controller

  alias Tfcon.{Accounts, Guardian}

  def create(conn, %{"account_number" => account_number, "password" => password}) do
    Accounts.authenticate_user(account_number, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    encode = Guardian.encode_and_sign(user)
    {:ok, token, _} = encode

    json(conn, %{token: token})
  end
  defp login_reply({:error, reason}, conn) do
    conn
    |> put_status(401)
    |> json(%{errors: [reason]})
  end
end
