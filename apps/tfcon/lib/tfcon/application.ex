defmodule Tfcon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Tfcon.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tfcon.Supervisor)
  end
end
