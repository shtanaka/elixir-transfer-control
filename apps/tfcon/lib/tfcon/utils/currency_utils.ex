defmodule Tfcon.Utils.CurrencyUtils do
  @moduledoc """
  The Currency utils is used for managing every logic related to currencies
  """

  @doc """
  transform float to BRL text

  ## Example

      iex> float(50.5)
      "R$ 50,50"
  """
  def float_to_brl(number),
    do: "R$ " <> String.replace(:erlang.float_to_binary(number / 1, decimals: 2), ".", ",")
end
