# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ellion,
  namespace: EllionCore,
  ecto_repos: [EllionCore.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :ellion, EllionWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: EllionWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EllionCore.PubSub,
  live_view: [signing_salt: "1DA6t87e"]

# Configures the database timezone
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configures Joken JWT secret key
config :joken,
  default_signer:
    System.get_env(
      "JWT_SECRET_KEY",
      "brQblD36K5Cw3mMsOr/dtk0Nf+oNtENaigrsHyJ2yn+Lzwo8zFEpsUL9xoa3sQY0"
    )

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
