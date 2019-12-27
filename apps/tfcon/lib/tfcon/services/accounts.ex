defmodule Tfcon.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Tfcon.Repo

  alias Tfcon.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user debit.

  ## Examples

      iex> debit_changeset(user, 300) # for a user with 1k in balance
      %Ecto.Changeset{source: %User{}, changes: %{balance: 700}

  """
  def debit_changeset(%User{} = user, amount) do
    User.changeset(user, %{ balance: user.balance - amount })
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user credit.

  ## Examples

      iex> debit_changeset(user, 300) # for a user with 1k in balance
      %Ecto.Changeset{source: %User{}, changes: %{balance: 1300}

  """
  def credit_changeset(%User{} = user, amount) do
    User.changeset(user, %{ balance: user.balance + amount })
  end
end
