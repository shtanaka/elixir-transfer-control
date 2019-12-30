defmodule Tfcon.Utils.CurrencyUtils do
  def float_to_brl(number),
    do: "R$ " <> String.replace(:erlang.float_to_binary(number / 1, decimals: 2), ".", ",")
end
