defmodule StationServerWeb.Modules.Weather do
  @behaviour StationServerWeb.AppModule

  @impl true
  def name, do: "Weather"

  @impl true
  def path, do: "/weather"

  @impl true
  def page_data do
    %{
      refresh_every: 30_000
    }
  end
end
