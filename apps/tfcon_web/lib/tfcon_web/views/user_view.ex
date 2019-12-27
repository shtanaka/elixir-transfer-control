defmodule TfconWeb.UserView do
  use TfconWeb, :view
  alias Tfcon.Json.ErrorHandler

  @minimal_attrs ~W(name account_number)a
  # @expanded_attrs ~W(name account_number balance)a

  def render("404.json", _) do
    %{"errors" => ["Entity not found."]}
    |> ErrorHandler.error_json()
  end
  def render("show.json", %{user: user}) do
    user
    |> Map.take(@minimal_attrs)
    |> ErrorHandler.success_json()
  end
  def render("index.json", %{users: users}) do
    Enum.map(users, fn user -> Map.take(user, @minimal_attrs) end)
    |> ErrorHandler.success_json()
  end
end
