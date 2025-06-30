defmodule StationServerWeb.Images.WeatherController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  def show(conn, _params) do
    weather_data = get_weather_data()

    assigns = %{
      temperature: weather_data.temperature,
      condition: weather_data.condition,
      location: weather_data.location,
      updated_at: format_time(weather_data.updated_at),
      links: AppModule.links(StationServerWeb.Modules.Weather)
    }

    conn
    |> render(assigns)
  end

  defp get_weather_data do
    %{
      temperature: 22,
      condition: "Partly Cloudy",
      location: "Downtown",
      updated_at: DateTime.utc_now()
    }
  end

  defp format_time(datetime) do
    Calendar.strftime(datetime, "%H:%M")
  end
end
