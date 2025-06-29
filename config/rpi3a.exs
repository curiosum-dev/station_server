import Config

# Add configuration that is only needed when running on the Raspberry Pi 3A target

# Configure the endpoint for Nerves environment
config :station_server, StationServerWeb.Endpoint,
  # Start the server since we're running in a release
  server: true,
  # Use HTTP instead of HTTPS for embedded deployment
  url: [host: "station-server.local", port: 4000],
  http: [
    # Listen on all interfaces
    ip: {0, 0, 0, 0},
    port: 4000
  ],
  # Disable code reloader
  code_reloader: false,
  # Disable check_origin for embedded use
  check_origin: false

# Disable phoenix live dashboard for embedded deployment
config :station_server, StationServerWeb.Endpoint, live_dashboard: false

# Configure logger for Nerves
config :logger,
  level: :info,
  backends: [RingLogger]

# For production-like behavior in embedded systems
config :phoenix, :serve_endpoints, true
