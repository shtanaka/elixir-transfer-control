defmodule TfconWeb.ReportController do
  use TfconWeb, :controller
  alias Tfcon.BankReports
  alias Tfcon.Utils.DateUtils
  alias Tfcon.Utils.CurrencyUtils

  def day_report(conn, _params) do
    {total, transactions} = BankReports.bank_transactions_of_today() |> total_and_transactions()
    render(conn, "day_report.html", %{transactions: transactions, total: total})
  end

  def month_report(conn, _params) do
    {total, transactions} =
      BankReports.bank_transactions_of_the_month() |> total_and_transactions()

    render(conn, "month_report.html", %{transactions: transactions, total: total})
  end

  def year_report(conn, _params) do
    {total, transactions} =
      BankReports.bank_transactions_of_the_year() |> total_and_transactions()

    render(conn, "year_report.html", %{transactions: transactions, total: total})
  end

  def all_time_report(conn, _params) do
    {total, transactions} = BankReports.all_bank_transactions() |> total_and_transactions()
    render(conn, "all_time_report.html", %{transactions: transactions, total: total})
  end

  defp total_and_transactions(data),
    do: {prepare_total(data) |> CurrencyUtils.float_to_brl(), prepare_transactions(data)}

  defp prepare_total(data) do
    Enum.reduce(data, 0, fn tr, acc -> acc + tr.amount end)
  end

  defp prepare_transactions(data) do
    Enum.map(data, fn tr ->
      {tr.bank_transaction_id, DateUtils.format_datetime_to_read(tr.inserted_at),
       CurrencyUtils.float_to_brl(tr.amount)}
    end)
  end
end
