defmodule StationServerWeb.Modules.Weather do
  @behaviour StationServerWeb.AppModule

  @impl true
  def name, do: "Pogoda"

  @impl true
  def path, do: "/weather"

  @impl true
  def image_path(_assigns), do: "/images/weather.png"

  @impl true
  def page_data do
    %{
      refresh_every: 15 * 60_000
    }
  end

  @impl true
  def extra_links(_params) do
    %{}
  end
end
