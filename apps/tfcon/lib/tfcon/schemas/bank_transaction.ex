defmodule Tfcon.Bank.BankTransaction do
  @moduledoc """
  This schema is used for recording all transactions in the API

  All fields are required.

  fields:
  * amount - total of the money in the transaction
  * from - user that transferred the ammount
  * to - user that received the amount
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tfcon.Utils.DateUtils
  @timestamps_opts [autogenerate: {DateUtils, :naive_now, [:naive_datetime]}]

  @primary_key {:bank_transaction_id, :binary_id, autogenerate: true}
  schema "bank_transactions" do
    field :amount, :float
    field :from_id, :binary_id
    field :to_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(bank_transaction, attrs) do
    bank_transaction
    |> cast(attrs, [:amount, :from_id, :to_id])
    |> validate_required([:amount, :from_id, :to_id])
  end
end
