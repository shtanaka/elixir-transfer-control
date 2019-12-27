defmodule Tfcon.Bank do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Tfcon.Repo
  alias Ecto.Multi

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

  """
  def transfer(%User{} = _, %User{} = _, amount) when amount < 0, do: {:error, :amount_negative}
  def transfer(%User{} = from, %User{} = to, amount) do
    Multi.new()
    |> Multi.update(:from, Accounts.debit_changeset(from, amount))
    |> Multi.update(:to, Accounts.credit_changeset(to, amount))
    |> Repo.transaction()
  end
end
