defmodule Tfcon.Fixtures do
  def user do
    alias Tfcon.Accounts

    quote do
      @valid_password "somepassword"
      @valid_attrs %{name: "some name", password: @valid_password}
      @second_valid_attrs %{name: "some name", password: @valid_password}

      def user_fixture(attrs \\ %{}) do
        {:ok, user} =
          attrs
          |> Enum.into(@valid_attrs)
          |> Accounts.create_user()

        user
      end

      def second_user_fixture(attrs \\ %{}) do
        {:ok, user} =
          attrs
          |> Enum.into(@second_valid_attrs)
          |> Accounts.create_user()

        user
      end
    end
  end

  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture), do: apply(__MODULE__, fixture, [])
  end
end
