defmodule Tfcon.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :account_number, :integer
      add :balance, :float

      timestamps()
    end

    create unique_index(:users, [:account_number])
  end
end
