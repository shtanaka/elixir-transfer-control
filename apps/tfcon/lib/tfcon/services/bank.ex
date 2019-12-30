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
  def transfer(
        %User{account_number: from_account_number},
        %User{account_number: to_account_number},
        _
      )
      when from_account_number == to_account_number,
      do: {:error, :no_self_transfer}
  def transfer(%User{} = _, %User{} = _, amount) when amount <= 0, do: {:error, :amount_negative}
end
