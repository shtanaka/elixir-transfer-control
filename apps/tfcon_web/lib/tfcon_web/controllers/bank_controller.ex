defmodule TfconWeb.BankController do
  use TfconWeb, :controller

  def my_account(%{private: %{guardian_default_resource: user}} = conn, _) do
    render(conn, "my_account.json", %{user: user})
  end
end
