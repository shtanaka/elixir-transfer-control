defmodule Tfcon.Guardian.ErrorHandler do
  import Plug.Conn
  alias Tfcon.JsonHandler

  @behaviour Guardian.Plug.ErrorHandler
  @impl Guardian.Plug.ErrorHandler

  def auth_error(conn, {_type, _reason}, _opts) do
    body =
      JsonHandler.error_json(%{errors: ["You are not authorized."]})
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
