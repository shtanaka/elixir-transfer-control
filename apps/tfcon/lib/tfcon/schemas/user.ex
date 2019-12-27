defmodule Tfcon.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :account_number, :integer
    field :name, :string
    field :balance, :float, default: 1000.0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :account_number])
    |> validate_required([:name, :account_number])
    |> validate_number(:balance, greater_than_or_equal_to: 0.0)
    |> unique_constraint(:account_number)
  end
end
