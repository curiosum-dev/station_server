defmodule StationServerWeb.Images.WeatherController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  def show(conn, _params) do
    current_weather_data = StationServerWeb.External.Weather.Current.get_current_weather_data()
    today_weather_data = StationServerWeb.External.Weather.Today.get_today_weather_data()

    current_time =
      NaiveDateTime.local_now()
      |> NaiveDateTime.to_time()
      |> to_string()
      |> String.split(":")
      |> Enum.take(2)
      |> Enum.join(":")

    assigns =
      current_weather_data
      |> Map.merge(%{
        links: AppModule.navigation_links(StationServerWeb.Modules.Weather),
        today_weather: today_weather_data.today,
        next_days_weather: today_weather_data.next_days,
        current_time: current_time
      })
      |> Map.merge(current_weather_data)

    conn
    |> render(assigns)
  end
end
