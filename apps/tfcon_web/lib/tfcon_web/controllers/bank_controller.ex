defmodule TfconWeb.BankController do
  use TfconWeb, :controller
  alias Tfcon.{Accounts, Bank}

  def my_account(%{private: %{guardian_default_resource: user}} = conn, _) do
    render(conn, "my_account.json", %{user: user})
  end

  def transfer(%{private: %{guardian_default_resource: from}} = conn, %{
        "account_number" => account_number,
        "amount" => amount
      }) do
    to = Accounts.get_user_by_account_number!(account_number)
    do_transfer(conn, from, to, amount)
  end

  defp do_transfer(conn, _, nil, _),
    do: conn |> put_status(404) |> render("404.json", %{user: nil})
  defp do_transfer(conn, from, to, amount) do
    do_transfer(conn, Bank.transfer(from, to, amount))
  end
  defp do_transfer(conn, {:error, :from, changeset, %{}}),
    do: conn |> put_status(400) |> render("no_balance.json", %{changeset: changeset})
  defp do_transfer(conn, {:ok, %{from: _, to: _} = transfer_data}) do
    render(conn, "transfer.json", transfer_data)
  end
end
