defmodule Tfcon.BankTest do
  use Tfcon.DataCase

  alias Tfcon.Accounts
  alias Tfcon.Bank
  alias Tfcon.Accounts.User

  describe "users" do
    def from_to_fixture(attrs \\ %{}) do
      {:ok, from} =
        attrs
        |> Enum.into(%{name: "Some From Name"})
        |> Accounts.create_user()

      {:ok, to} =
        attrs
        |> Enum.into(%{name: "Some To Name"})
        |> Accounts.create_user()

      {from, to}
    end

    test "transfer/3 transfers money from one user to another if from balance is ok" do
      {from, to} = from_to_fixture()
      assert {:ok, %{from: %User{}, to: %User{}}} = Bank.transfer(from, to, 900)
    end

    test "transfer/3 transfers the right amount from one user to another" do
      {from, to} = from_to_fixture()
      assert {:ok, %{from: updated_from, to: updated_to}} = Bank.transfer(from, to, 900)
      assert updated_from.balance == 100.0
      assert updated_to.balance == 1900.0
    end

    test "transfer/3 does not transfer a negative amount" do
      {from, to} = from_to_fixture()
      assert {:ok, %{from: updated_from, to: updated_to}} = Bank.transfer(from, to, 900)
    end

    test "transfer/3 does not transfer money from one user to another if balance is below transfer amount" do
      {from, to} = from_to_fixture()
      assert {:error, :from, %Ecto.Changeset{valid?: false}, %{}} = Bank.transfer(from, to, 1100)
    end

    test "transfer/3 does not transfer money from one user to another if transfer amount is negative" do
      {from, to} = from_to_fixture()
      assert {:error, :amount_negative} = Bank.transfer(from, to, -1100)
    end
  end
end
