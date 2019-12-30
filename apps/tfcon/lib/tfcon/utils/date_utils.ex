defmodule Tfcon.Utils.DateUtils do
  def naive_today() do
    iso_today = Date.utc_today() |> Date.to_iso8601()
    {:ok, naive_today} = NaiveDateTime.new(Date.from_iso8601!(iso_today), ~T[00:00:00])

    naive_today
  end

  def naive_first_day_of_month() do
    today = Date.utc_today()
    iso_first_day_of_month = "#{today.year}-#{today.month}-01"
    {:ok, naive_first_day_of_month} =
      NaiveDateTime.new(Date.from_iso8601!(iso_first_day_of_month), ~T[00:00:00])

    naive_first_day_of_month
  end

  def naive_first_day_of_year() do
    today = Date.utc_today()
    iso_first_day_of_year = "#{today.year}-01-01"
    {:ok, naive_first_day_of_year} =
      NaiveDateTime.new(Date.from_iso8601!(iso_first_day_of_year), ~T[00:00:00])

    naive_first_day_of_year
  end
end
