defmodule Tfcon.Repo do
  use Ecto.Repo,
    otp_app: :tfcon,
    adapter: Ecto.Adapters.Postgres
end
