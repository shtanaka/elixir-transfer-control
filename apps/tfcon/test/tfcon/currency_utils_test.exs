defmodule Tfcon.DateUtilsTest do
  use Tfcon.DataCase

  alias Tfcon.Utils.CurrencyUtils

  describe "currency utils" do
    test "float_to_brl/1 gets BRL text value of a float" do
      assert CurrencyUtils.float_to_brl(32.5) == "R$ 32,50"
    end
  end
end
