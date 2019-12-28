defmodule TfconWeb.UserView do
  use TfconWeb, :view
  alias Tfcon.JsonHandler
  alias Ecto.Changeset

  @minimal_attrs ~W(name account_number)a
  @expanded_attrs ~W(name account_number balance)a

  def render("400.json", %{changeset: changeset}) do
    errors =
      Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
    JsonHandler.error_json(%{"errors" => errors})
  end
  def render("404.json", _) do
    JsonHandler.error_json(%{"errors" => ["Entity not found."]})
  end
  def render("index.json", %{users: users}) do
    user_list = Enum.map(users, fn user -> Map.take(user, @minimal_attrs) end)
    JsonHandler.success_json(%{users: user_list})
  end
  def render("show.json", %{user: user}) do
    user_data = Map.take(user, @minimal_attrs)
    JsonHandler.success_json(%{user: user_data})
  end
  def render("create.json", %{user: user, token: token}) do
    user_data = Map.take(user, @expanded_attrs)
    JsonHandler.success_json(%{user: user_data, token: token})
  end
end
