defmodule Tfcon.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, warn: false
  alias Tfcon.Repo

  @primary_key {:user_id, :binary_id, autogenerate: true}
  schema "users" do
    field :name, :string
    field :account_number, :integer, unique: true
    field :balance, :float, default: 1000.0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :account_number, :balance])
    |> account_number()
    |> validate_required([:name, :account_number])
    |> validate_number(:balance, greater_than_or_equal_to: 0.0)
    |> unique_constraint(:account_number)
  end

  defp account_number(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, data: %{account_number: nil}} ->
        put_change(changeset, :account_number, generate_account_number())
      _ ->
        changeset
    end
  end

  defp generate_account_number() do
    Repo.one(from u in "users", select: count(u.user_id)) + 1
  end
end
