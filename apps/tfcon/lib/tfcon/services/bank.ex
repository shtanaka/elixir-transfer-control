defmodule Tfcon.Bank do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Tfcon.Repo
  alias Ecto.Multi

  alias Tfcon.Accounts
  alias Tfcon.Accounts.User

  @doc """
  transfer amouunt from one user to another. changes both users.

  ## Examples

      iex> deposit(user, 30)
      {:ok, %User{}} # with amount increased by 30

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def transfer(%User{} = from, %User{} = to, amount) do
    Multi.new()
    # |> Multi.update(:from, User)
    # |> User.changeset(%User{user | balance: user.balance + amount})
    # |> Repo.update()
  end
end
