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
    hostname_pattern: "station-server-%s"
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
  # advertises "station-server.local".
  hosts: [:hostname, "station-server"],
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
    }
  ]

# Import secrets
import_config "target.secrets.exs"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
target = Mix.target()

if target != :host do
  import_config "#{target}.exs"
end
