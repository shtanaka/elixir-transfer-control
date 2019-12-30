defmodule Tfcon.Bank.BankTransaction do
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
