defmodule StationServer.MixProject do
  use Mix.Project

  @app :station_server
  @version "0.1.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [{@app, release()}]
    ] ++ project_listeners()
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {StationServer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Phoenix deps
      {:phoenix, "~> 1.8.0-rc.0", override: true},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:resvg, "~> 0.5.0"},
      {:req, "~> 0.5.14"},
      {:tzdata, "~> 1.1.3"},

      # Nerves deps - only for embedded targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1", targets: [:rpi]},
      {:ring_logger, "~> 0.8.5", targets: [:rpi]},
      {:toolshed, "~> 0.4.0", targets: [:rpi]},
      {:nerves_runtime, "~> 0.13.0", targets: [:rpi]},
      {:nerves_pack, "~> 0.7.0", targets: [:rpi]},
      {:nerves_time_zones, "~> 0.3.2", targets: [:rpi]},

      # Nerves System - use a GitHub repository or a local one, picked to match
      # your hardware.
      {:nerves_system_rpi3a, "~> 1.23", runtime: false, targets: :rpi}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Only include listeners for host target, not for embedded targets
  defp project_listeners do
    case Mix.target() do
      :host -> [listeners: [Phoenix.CodeReloader]]
      _ -> []
    end
  end

  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
