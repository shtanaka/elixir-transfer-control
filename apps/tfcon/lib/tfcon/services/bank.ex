defmodule Tfcon.Bank do
  @moduledoc """
  The Bank context is used for perfoming regular bank operations,
  like transfers and withdraw
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Tfcon.Repo
  alias Tfcon.Bank.BankTransaction
  alias Tfcon.Accounts
  alias Tfcon.Accounts.User
  alias Tfcon.Utils.CurrencyUtils

  @doc """
  transfer amount from one user to another. changes both users.

  ## Examples

      iex> transfer(from, to, 30)
      {:ok, %{from: %User{}, to: %User}} # with amount increased by 30

      iex> transfer(from, to, more_than_from_balance)
      {:error, :from, %Ecto.Changeset{}, %{}}

      iex> transfer(from, to, negative_amount)
      {:error, :amount_negative}

      iex> transfer(from, from, negative_amount)
      {:error, :no_self_transfer}
  """
  def transfer(
        %User{account_number: from_account_number},
        %User{account_number: to_account_number},
        _
      )
      when from_account_number == to_account_number,
      do: {:error, :no_self_transfer}
  def transfer(%User{} = _, %User{} = _, amount) when amount <= 0, do: {:error, :amount_negative}
  def transfer(%User{} = from, %User{} = to, amount) do
    float_amount = amount / 1

    Multi.new()
    |> Multi.update(:from, Accounts.debit_changeset(from, float_amount))
    |> Multi.update(:to, Accounts.credit_changeset(to, float_amount))
    |> Multi.insert(
      :bank_transaction,
      BankTransaction.changeset(%BankTransaction{}, %{
        from_id: from.user_id,
        to_id: to.user_id,
        amount: float_amount
      })
    )
    |> Repo.transaction()
  end

  def withdraw(%User{} = _, amount) when amount <= 0, do: {:error, :amount_negative}
  def withdraw(%User{} = from, amount) do
    Accounts.update_user(from, %{balance: Float.round(from.balance - amount / 1, 2)})
    |> log_withdraw(amount)
  end

  defp log_withdraw({:ok, updated_from} = data, amount) do
    IO.puts(
      "Withdraw #{CurrencyUtils.float_to_brl(amount)} successfully from account ##{
        updated_from.account_number
      }."
    )

    data
  end
  defp log_withdraw({:error, _} = data, _) do
    IO.puts("Couldn't withdraw. Not enough balance.")
    data
  end
end
