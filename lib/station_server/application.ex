defmodule StationServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Initialize locale from configuration
    StationServerWeb.Locale.init_locale()

    # Define children based on target
    children =
      [
        StationServerWeb.Telemetry,
        {Phoenix.PubSub, name: StationServer.PubSub},
        # Start to serve requests, typically the last entry
        StationServerWeb.Endpoint
      ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StationServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StationServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
