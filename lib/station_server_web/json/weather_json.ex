defmodule StationServerWeb.Pages.WeatherJSON do
  import StationServerWeb.Links

  def index(_params \\ %{}) do
    %{
      picture: "/images/weather.png",
      refresh_every: 30_000,
      touch: links("/") |> links_to_touch_regions()
    }
  end
end
