defmodule StationServerWeb.Modules.Weather do
  @behaviour StationServerWeb.AppModule

  @impl true
  def name, do: "Pogoda"

  @impl true
  def path, do: "/weather"

  @impl true
  def page_data do
    %{
      refresh_every: 15 * 60_000
    }
  end
end
