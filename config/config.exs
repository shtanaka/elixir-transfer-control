# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :tfcon,
  ecto_repos: [Tfcon.Repo]

config :tfcon_web,
  ecto_repos: [Tfcon.Repo],
  generators: [context_app: :tfcon]

# Configures the endpoint
config :tfcon_web, TfconWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sLOhiIfwtOLlNrh3ChBIAmpqp/9iDjEvsdc8lyiHEaFHn4gmjSAvikBHZq2lxut2",
  render_errors: [view: TfconWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TfconWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
