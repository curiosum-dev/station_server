defmodule StationServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Define children based on target
    children =
      [
        StationServerWeb.Telemetry,
        {Phoenix.PubSub, name: StationServer.PubSub},
        # Start to serve requests, typically the last entry
        StationServerWeb.Endpoint
      ] ++ children(target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StationServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Specify target specific children here
  defp children(:host) do
    [
      {DNSCluster, query: Application.get_env(:station_server, :dns_cluster_query) || :ignore}
    ]
  end

  defp children(_target) do
    # For embedded targets, skip DNSCluster and other host-only services
    []
  end

  defp target do
    Application.get_env(:station_server, :target) || :host
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StationServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
