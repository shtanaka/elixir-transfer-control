defmodule Tfcon.BankTest do
  use Tfcon.DataCase

  alias Tfcon.Bank
  alias Tfcon.Accounts
  alias Tfcon.Accounts.User

  describe "bank" do
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

    test "transfer/3 does not transfer money from one user to another if balance is below transfer amount" do
      {from, to} = from_to_fixture()
      assert {:error, :from, %Ecto.Changeset{valid?: false}, %{}} = Bank.transfer(from, to, 1100)
    end

    test "transfer/3 does not transfer money from one user to another if transfer amount is negative" do
      {from, to} = from_to_fixture()
      assert {:error, :amount_negative} = Bank.transfer(from, to, -1100)
    end

    test "transfer/3 does not transfer money from for the same account" do
      {from, _} = from_to_fixture()
      assert {:error, :no_self_transfer} = Bank.transfer(from, from, 1000)
    end

    test "transfer/3 saves a bank transaction entity when money is transferred" do
      {from, to} = from_to_fixture()
      assert {:ok, %{bank_transaction: bank_transaction}} = Bank.transfer(from, to, 900)
      assert bank_transaction.from_id == from.user_id
      assert bank_transaction.to_id == to.user_id
      assert bank_transaction.amount == 900
    end

    test "withdraw/2 properly withdraw money" do
      {from, _} = from_to_fixture()
      assert {:ok, from} = Bank.withdraw(from, 900)
      assert from.balance == 100
    end

    test "withdraw/2 wont withdraw if no limit" do
      {from, _} = from_to_fixture()
      assert {:error, _} = Bank.withdraw(from, 1100)
    end

    test "withdraw/2 wont withdraw if amount is negative" do
      {from, _} = from_to_fixture()
      assert {:error, :amount_negative} = Bank.withdraw(from, -1100)
    end
  end
end
