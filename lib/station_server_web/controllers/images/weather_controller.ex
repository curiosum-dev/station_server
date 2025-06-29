defmodule StationServerWeb.Images.WeatherController do
  use StationServerWeb, :controller

  import StationServerWeb.Links
  alias StationServerWeb.SVG2PNG

  def show(conn, _params) do
    weather_data = get_weather_data()

    assigns = %{
      temperature: weather_data.temperature,
      condition: weather_data.condition,
      location: weather_data.location,
      updated_at: format_time(weather_data.updated_at),
      links: links("/")
    }

    case SVG2PNG.render_svg_to_png("weather.svg.eex", assigns) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate weather image: #{reason}"})
    end
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
