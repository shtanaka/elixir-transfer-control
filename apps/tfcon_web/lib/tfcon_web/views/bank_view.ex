defmodule TfconWeb.BankView do
  use TfconWeb, :view
  alias Tfcon.JsonHandler
  alias Ecto.Changeset

  @minimal_attrs ~W(name account_number)a
  @expanded_attrs ~W(name account_number balance)a

  def render("404.json", _) do
    JsonHandler.error_json(%{"errors" => ["Entity not found."]})
  end
  def render("no_balance.json", %{changeset: changeset}) do
    errors =
      Changeset.traverse_errors(changeset, fn
        {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
        msg ->
          msg
      end)

    JsonHandler.error_json(%{"errors" => errors})
  end
  def render("my_account.json", %{user: user}) do
    user_data = Map.take(user, @expanded_attrs)
    JsonHandler.success_json(%{user: user_data})
  end
  def render("transfer.json", %{from: from, to: to}) do
    from_data = Map.take(from, @expanded_attrs)
    to_data = Map.take(to, @minimal_attrs)

    JsonHandler.success_json(%{
      from: from_data,
      to: to_data,
      message:
        "value successfully transfered from #{from.account_number} to #{to.account_number}."
    })
  end
  def render("withdraw.json", %{user: user}) do
    user_data = Map.take(user, @expanded_attrs)

    JsonHandler.success_json(%{
      user: user_data,
      message: "value successfully debited from #{user.account_number}."
    })
  end
end
