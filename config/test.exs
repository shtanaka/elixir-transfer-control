use Mix.Config

# Configure your database
config :tfcon, Tfcon.Repo,
  username: "postgres",
  password: "postgres",
  database: "tfcon_test",
  hostname: System.get_env("DB_HOST"),
  port: System.get_env("DB_PORT"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tfcon_web, TfconWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
