# Add configuration that is only needed when running on the Raspberry Pi 3A target
import Config

# Use shoehorn to start the main application. See the shoehorn
# library documentation for more control in ordering how OTP
# applications are started and handling failures.
config :shoehorn, init: [:nerves_runtime, :nerves_pack]

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Erlinit can be configured without a rootfs_overlay. See
# https://github.com/nerves-project/erlinit/ for more information on
# configuring erlinit.
config :nerves,
  erlinit: [
    hostname_pattern: "station_server-%s"
  ]

# Configure the device for SSH IEx prompt access and firmware updates
#
# * See https://hexdocs.pm/nerves_ssh/readme.html for general SSH configuration
# * See https://hexdocs.pm/ssh_subsystem_fwup/readme.html for firmware updates

keys =
  [
    Path.join([__DIR__, "..", "nerves_key"]),
    Path.join([__DIR__, "..", "nerves_key.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [] do
  Mix.raise("""
  No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
  log into the Nerves device and update firmware on it using ssh.
  See your project's config/target.exs for this error message.
  """)
end

config :nerves_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

config :mdns_lite,
  # The `hosts` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  The `"station_server"` example
  # advertises "station_server.local".
  hosts: [:hostname, "station_server"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    },
    %{
      protocol: "http",
      transport: "tcp",
      port: 4000
    }
  ]

config :nerves_time_zones, default_time_zone: "Europe/Warsaw"

# Import secrets
import_config "rpi.secrets.exs"

# Configure the endpoint for Nerves environment
config :station_server, StationServerWeb.Endpoint,
  # Start the server since we're running in a release
  server: true,
  # Use HTTP instead of HTTPS for embedded deployment
  url: [host: "station_server.local", port: 4000],
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

# Language configuration for Raspberry Pi (can be changed per deployment)
config :station_server, :language, "en"

# For production-like behavior in embedded systems
config :phoenix, :serve_endpoints, true
