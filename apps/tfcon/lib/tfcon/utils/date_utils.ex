defmodule Tfcon.Utils.DateUtils do
  def utc_now(), do: DateTime.utc_now()

  def naive_now(), do: utc_now() |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
  def naive_now(_), do: naive_now()

  def utc_today(), do: Date.utc_today()

  def naive_today() do
    iso_today = utc_today() |> Date.to_iso8601()
    {:ok, naive_today} = NaiveDateTime.new(Date.from_iso8601!(iso_today), ~T[00:00:00])

    naive_today
  end

  def utc_first_day_of_month() do
    today = utc_today()

    {:ok, date} =
      "#{today.year}-#{today.month}-01"
      |> Date.from_iso8601()

    date
  end

  def naive_first_day_of_month() do
    {:ok, naive_first_day_of_month} =
      utc_first_day_of_month()
      |> NaiveDateTime.new(~T[00:00:00])

    naive_first_day_of_month
  end

  def utc_first_day_of_year() do
    today = utc_today()

    {:ok, date} =
      "#{today.year}-01-01"
      |> Date.from_iso8601()

    date
  end

  def naive_first_day_of_year() do
    {:ok, naive_first_day_of_year} =
      utc_first_day_of_year()
      |> NaiveDateTime.new(~T[00:00:00])

    naive_first_day_of_year
  end

  def format_date_to_read(date) do
    d = [date.day, date.month, date.year] |> Enum.join("/")
    t = [date.hour, date.minute, date.second] |> Enum.join(":")

    d <> " " <> t
  end
end
