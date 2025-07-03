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
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
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

      # Nerves deps - only for embedded targets
      {:nerves, "~> 1.10", runtime: false, targets: [:rpi4, :rpi3a]},
      {:shoehorn, "~> 0.9.1", targets: [:rpi4, :rpi3a]},
      {:ring_logger, "~> 0.8.5", targets: [:rpi4, :rpi3a]},
      {:toolshed, "~> 0.4.0", targets: [:rpi4, :rpi3a]},
      {:nerves_runtime, "~> 0.13.0", targets: [:rpi4, :rpi3a]},
      {:nerves_pack, "~> 0.7.0", targets: [:rpi4, :rpi3a]},
      {:nerves_system_rpi4, "~> 1.23", runtime: false, targets: :rpi4},
      {:nerves_system_rpi3a, "~> 1.23", runtime: false, targets: :rpi3a}
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

  defp aliases do
    [
      setup: ["deps.get"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
