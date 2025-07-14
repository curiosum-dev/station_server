defmodule StationServerWeb.Images.WeatherController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  def show(conn, _params) do
    current_weather_data = StationServerWeb.External.Weather.Current.get_current_weather_data()
    today_weather_data = StationServerWeb.External.Weather.Today.get_today_weather_data()

    assigns =
      current_weather_data
      |> Map.merge(%{
        links: AppModule.links(StationServerWeb.Modules.Weather),
        today_weather: today_weather_data.today,
        next_days_weather: today_weather_data.next_days
      })
      |> Map.merge(current_weather_data)

    conn
    |> render(assigns)
  end
end
