use Mix.Config

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
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :logger, level: :info

config :tfcon_web, TfconWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json",
  url: [host: System.get_env("APP_HOST"), port: System.get_env("APP_PORT")],
  http: [:inet6, port: String.to_integer(System.get_env("APP_PORT") || "4000")]
