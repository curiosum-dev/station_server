import Config

# Configuration for running on host (development/testing)
# Disable Nerves-specific components that don't work on macOS/host systems

# Don't start networking components on host
config :vintage_net, persist_data_path: nil
config :vintage_net, network: false

# Disable nerves time on host
config :nerves_time, servers: []

# Use standard logger instead of ring logger on host
config :logger, backends: [:console]

# Configure for development-like behavior
config :station_server, StationServerWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
