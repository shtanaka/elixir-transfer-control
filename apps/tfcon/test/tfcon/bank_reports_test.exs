defmodule Tfcon.BankTest do
  use Tfcon.DataCase
  import Mock

  alias Tfcon.Bank
  alias Tfcon.BankReports
  alias Tfcon.Bank.BankTransaction
  alias Tfcon.Accounts
  alias Tfcon.Accounts.User
  alias Tfcon.Utils.DateUtils

  describe "users" do
    @mock_date_today NaiveDateTime.add(DateUtils.naive_today(), 3600, :second)
    @mock_date_month DateUtils.naive_first_day_of_month()
    @mock_date_year DateUtils.naive_first_day_of_year()
    @mock_date_after_year NaiveDateTime.add(
                            DateUtils.naive_first_day_of_year(),
                            -216_000,
                            :second
                          )

    def from_to_transactions_fixture(attrs \\ %{}) do
      {:ok, from} =
        attrs
        |> Enum.into(%{name: "Some From Name"})
        |> Accounts.create_user()

      {:ok, to} =
        attrs
        |> Enum.into(%{name: "Some To Name"})
        |> Accounts.create_user()

      # transactions are performed in different dates

      with_mock DateUtils, naive_now: fn _ -> @mock_date_month end do
        Bank.transfer(from, to, 50)
      end

      with_mock DateUtils, naive_now: fn _ -> @mock_date_month end do
        Bank.transfer(from, to, 100)
      end

      with_mock DateUtils, naive_now: fn _ -> @mock_date_year end do
        Bank.transfer(from, to, 200)
      end

      with_mock DateUtils, naive_now: fn _ -> @mock_date_after_year end do
        Bank.transfer(from, to, 400)
      end

      {from, to}
    end

    test "all_bank_transactions/0 returns all transactions" do
      from_to_transactions_fixture()
      assert length(BankReports.all_bank_transactions()) == 4
    end

    test "bank_transactions_of_the_year/0 returns list of transactions of the year" do
      from_to_transactions_fixture()
      assert length(BankReports.bank_transactions_of_the_year()) == 3
    end

    test "bank_transactions_of_the_month/0 returns list of transactions of the month" do
      from_to_transactions_fixture()
      assert length(BankReports.bank_transactions_of_the_month()) == 2
    end

    test "bank_transactions_of_today/0 returns list of transactions of today" do
      from_to_transactions_fixture()
      assert length(BankReports.bank_transactions_of_today()) == 1
    end
  end
end
