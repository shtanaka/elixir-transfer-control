defmodule Tfcon.DateUtilsTest do
  use Tfcon.DataCase

  alias Tfcon.Utils.DateUtils

  describe "date utils" do
    test "utc_now/0 gets the same value of utc_now" do
      a = DateUtils.utc_now()
      b = DateTime.utc_now()
      assert a.month == b.month
      assert a.day == b.day
      assert a.year == b.year
    end

    test "naive_now/0 gets naive date" do
      assert %NaiveDateTime{} = DateUtils.naive_now()
    end

    test "naive_now/1 gets naive date" do
      assert %NaiveDateTime{} = DateUtils.naive_now("_")
    end

    test "utc_first_day_of_month/0 returns first day of current month" do
      a = DateUtils.utc_first_day_of_month()
      b = DateUtils.utc_now()

      assert a.year == b.year
      assert a.month == b.month
      assert a.day == 1
    end

    test "naive_first_day_of_month/0 gets naive date" do
      assert %NaiveDateTime{} = DateUtils.naive_first_day_of_month()
    end

    test "utc_first_day_of_year/0 returns first day of current year" do
      a = DateUtils.utc_first_day_of_year()
      b = DateUtils.utc_now()

      assert a.year == b.year
      assert a.month == 1
      assert a.day == 1
    end

    test "naive_first_day_of_year/0 gets naive date" do
      assert %NaiveDateTime{} = DateUtils.naive_first_day_of_year()
    end

    test "format_datetime_to_read/0 returns readable date" do
      date = ~U[2020-01-03 03:24:29.012588Z]
      assert DateUtils.format_datetime_to_read(date) == "3/1/2020 3:24:29"
    end
  end
end
