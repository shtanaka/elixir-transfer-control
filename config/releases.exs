import Config

DB_NAME
secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
app_port = System.fetch_env!("APP_PORT")
app_hostname = System.fetch_env!("APP_HOSTNAME")

config :demo, DemoWeb.Endpoint,
  http: [:inet6, port: String.to_integer(app_port)],
  secret_key_base: secret_key_base

config :demo,
  app_port: app_port

config :demo,
  app_hostname: app_hostname

config :tfcon, Tfcon.Repo,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST"),
  port: System.get_env("DB_PORT"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :tfcon, Tfcon.Guardian,
  issuer: "tfcon",
  secret_key: System.get_env("GUARDIAN_SECRET")
