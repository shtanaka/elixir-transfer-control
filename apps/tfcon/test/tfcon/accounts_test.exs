defmodule Tfcon.AccountsTest do
  use Tfcon.DataCase

  alias Tfcon.Accounts

  describe "users" do
    alias Tfcon.Accounts.User

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.user_id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
    end

    test "create_user/1 with valid data creates a user with 1k of balance" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.balance == 1000.0
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.user_id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.user_id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "debit_changeset/2 returns invalid status for balance over user balance" do
      user = user_fixture()
      assert %Ecto.Changeset{valid?: false} = Accounts.debit_changeset(user, 1100)
    end

    test "debit_changeset/2 returns valid status for balance under user balance" do
      user = user_fixture()
      assert %Ecto.Changeset{valid?: true} = Accounts.debit_changeset(user, 900)
    end

    test "credit_changeset/2 returns valid status for positive balance" do
      user = user_fixture()
      assert %Ecto.Changeset{valid?: true} = Accounts.credit_changeset(user, 1100)
    end

    test "credit_changeset/2 returns invalid status for negative balance bigger than user balance" do
      user = user_fixture()
      assert %Ecto.Changeset{valid?: false} = Accounts.credit_changeset(user, -1100)
    end
  end
end
