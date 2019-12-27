defmodule Tfcon.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :user_id, :uuid, primary_key: true
      add :account_number, :integer
      add :name, :string
      add :balance, :float
      add :password, :string

      timestamps()
    end

    create unique_index(:users, [:account_number])
  end
end
