defmodule Tfcon.Reports do
  import Ecto.Query, warn: false
  alias Tfcon.Repo
  alias Tfcon.Bank.BankTransaction
  alias Tfcon.Utils.DateUtils

  @doc """
  return list of all bank transactions in database
  """
  def all_bank_transactions() do
    query = from bt in BankTransaction, select: bt
    Repo.all(query)
  end

  @doc """
  return list of all bank transactions for today
  """
  def all_bank_transactions_of_today() do
    query =
      from bt in BankTransaction, where: bt.inserted_at > ^DateUtils.naive_today(), select: bt

    Repo.all(query)
  end

  @doc """
  return list of all bank transactions of the month
  """
  def all_bank_transactions_of_the_month() do
    query =
      from bt in BankTransaction,
        where: bt.inserted_at > ^DateUtils.naive_first_day_of_month(),
        select: bt

    Repo.all(query)
  end

  @doc """
  return list of all bank transactions of the year
  """
  def all_bank_transactions_of_the_year() do
    query =
      from bt in BankTransaction,
        where: bt.inserted_at > ^DateUtils.naive_first_day_of_year(),
        select: bt

    Repo.all(query)
  end
end
