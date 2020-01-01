defmodule Tfcon.Utils.DateUtils do
  @moduledoc """
  The date utils is used for managing every logic related to dates
  """

  @doc """
  utc_now/0 overrides DateTime utc_now

  ## Example
      iex> utc_now()
      ~U[2019-12-30 06:39:05.262481Z]
  """
  def utc_now(), do: DateTime.utc_now()

  @doc """
  naive_now/0, naive_now/1 naive DateTime of utc_now
  """
  def naive_now(), do: utc_now() |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
  def naive_now(_), do: naive_now()

  @doc """
  utc_today/0 get todays date

  ## Example
      iex> utc_today()
      ~D[2019-12-30]
  """
  def utc_today(), do: Date.utc_today()

  @doc """
  naive_today/0 get todays date naive
  """
  def naive_today() do
    iso_today = utc_today() |> Date.to_iso8601()
    {:ok, naive_today} = NaiveDateTime.new(Date.from_iso8601!(iso_today), ~T[00:00:00])

    naive_today
  end

  @doc """
  utc_first_day_of_month/0 get first day of current month

  ## Example
      iex> utc_first_day_of_month()
      ~D[2019-12-1]
  """
  def utc_first_day_of_month() do
    %{year: year, month: month} = utc_today()
    month =
      month
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    {:ok, date} = "#{year}-#{month}-01" |> Date.from_iso8601()

    date
  end

  @doc """
  utc_today/0 get first day of current month naive
  """
  def naive_first_day_of_month() do
    {:ok, naive_first_day_of_month} =
      utc_first_day_of_month()
      |> NaiveDateTime.new(~T[00:00:00])

    naive_first_day_of_month
  end

  @doc """
  utc_first_day_of_year/0 get first day of year

  ## Example
      iex> first_day_of_year()
      ~D[2019-01-01]
  """
  def utc_first_day_of_year() do
    today = utc_today()

    {:ok, date} =
      "#{today.year}-01-01"
      |> Date.from_iso8601()

    date
  end

  @doc """
  utc_today/0 get first day of year naive
  """
  def naive_first_day_of_year() do
    {:ok, naive_first_day_of_year} =
      utc_first_day_of_year()
      |> NaiveDateTime.new(~T[00:00:00])

    naive_first_day_of_year
  end

  @doc """
  format_datetime_to_read/1 format texts in a more readable way

  ## Example
      iex> format_datetime_to_read()
      "30/12/2019 12:00:00"
  """
  def format_datetime_to_read(date) do
    d = [date.day, date.month, date.year] |> Enum.join("/")
    t = [date.hour, date.minute, date.second] |> Enum.join(":")

    d <> " " <> t
  end
end
