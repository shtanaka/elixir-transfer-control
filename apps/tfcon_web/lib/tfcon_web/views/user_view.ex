defmodule TfconWeb.UserView do
  use TfconWeb, :view
  @minimal_attrs ~W(name account_number)a
  # @expanded_attrs ~W(name account_number balance)a

  def render("show.json", %{user: user}), do: user |> Map.take(@minimal_attrs)
  def render("index.json", %{users: users}), do: Enum.map(users, fn user -> Map.take(user, @minimal_attrs) end)
  def render("404.json", _), do: %{"error" => "Not found"}
end
