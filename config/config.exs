# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Start nerves_bootstrap
if Mix.target() != :host do
  Application.start(:nerves_bootstrap)
end

config :station_server,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :station_server, StationServerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: StationServerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: StationServer.PubSub,
  live_view: [signing_salt: "bQqkfJQp"]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
config :station_server, :default_time_zone, "Europe/Warsaw"

# Gettext configuration
config :station_server, StationServerWeb.Gettext,
  default_locale: "en",
  locales: ~w(en pl)

# Default language setting (configurable per environment)
config :station_server, :language, "pl"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Import target specific config for Nerves
target = Mix.target()

if Mix.target() != :host do
  import_config "#{target}.exs"
end
