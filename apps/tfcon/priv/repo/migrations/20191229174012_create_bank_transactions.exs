defmodule Tfcon.Repo.Migrations.CreateBankTransactions do
  use Ecto.Migration

  def change do
    create table(:bank_transactions, primary_key: false) do
      add :bank_transaction_id, :uuid, primary_key: true
      add :amount, :float
      add :from_id, references(:users, on_delete: :nothing, column: :user_id, type: :uuid)
      add :to_id, references(:users, on_delete: :nothing, column: :user_id, type: :uuid)

      timestamps()
    end

    create index(:bank_transactions, [:from_id])
    create index(:bank_transactions, [:to_id])
  end
end
