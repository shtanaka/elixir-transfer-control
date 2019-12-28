defmodule Tfcon.JsonHandler do
  def success_json(data), do: %{status: "success", data: data}
  def error_json(data), do: %{status: "error", data: data}
end
