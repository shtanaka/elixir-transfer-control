defmodule Tfcon.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :tfcon,
    error_handler: Tfcon.Guardian.ErrorHandler,
    module: Tfcon.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
