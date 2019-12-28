defmodule TfconWeb.BankView do
  use TfconWeb, :view
  alias Tfcon.JsonHandler

  @expanded_attrs ~W(name account_number balance)a

  def render("my_account.json", %{user: user}) do
    user_data = Map.take(user, @expanded_attrs)
    JsonHandler.success_json(%{user: user_data})
  end
end
