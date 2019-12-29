defmodule Tfcon.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Tfcon.Repo

  @primary_key {:user_id, :binary_id, autogenerate: true}
  schema "users" do
    field :name, :string
    field :account_number, :integer, unique: true
    field :password, :string
    field :balance, :float, default: 1000.0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :account_number, :balance, :password])
    |> put_account_number()
    |> unique_constraint(:account_number)
    |> validate_required([:name, :account_number])
    |> validate_number(:balance, greater_than_or_equal_to: 0.0)
    |> put_validate_balance_error_message()
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp generate_account_number() do
    Repo.one(from u in "users", select: count(u.user_id)) + 1
  end

  defp put_account_number(%Ecto.Changeset{valid?: true, data: %{account_number: nil}} = changeset) do
    put_change(changeset, :account_number, generate_account_number())
  end
  defp put_account_number(changeset), do: changeset

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
  end
  defp put_password_hash(changeset), do: changeset

  defp put_validate_balance_error_message(
         %Ecto.Changeset{valid?: false, errors: _} = changeset
       ) do
    update_in(
      changeset.errors,
      &Enum.map(&1, fn
        {:balance, _} -> {:balance, "Not enough balance"}
        {_key, _error} = tuple -> tuple
      end)
    )
  end
  defp put_validate_balance_error_message(changeset), do: changeset
end
