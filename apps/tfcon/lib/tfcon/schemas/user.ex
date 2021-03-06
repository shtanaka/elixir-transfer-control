defmodule Tfcon.Accounts.User do
  @moduledoc """
  This schema is used for storing the user information.

  Only name is required for create a user. However, you won't be able
  to authenticate without a password

  Account number and balance are auto generated.

  fields:
  * name - self described
  * password - self described
  * balance - user balance for transferring and withdraw
  * account_number - humanized identification for performing banking operatons
  """

  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Tfcon.Repo
  alias Tfcon.Utils.DateUtils
  @timestamps_opts [autogenerate: {DateUtils, :naive_now, [:naive_datetime]}]

  @primary_key {:user_id, :binary_id, autogenerate: true}
  schema "users" do
    field :name, :string
    field :password, :string
    field :balance, :float, default: 1000.0
    field :account_number, :integer, unique: true

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
