defmodule StationServerWeb.External.Weather.Current do
  @openweather_api_key Application.compile_env(:station_server, :openweather_api_key)

  def get_current_weather_data do
    payload =
      Req.get!(
        "https://api.openweathermap.org/data/2.5/weather?q=Poznan,PL&units=metric&lang=#{StationServerWeb.Locale.get_locale()}&appid=#{@openweather_api_key}"
      ).body

    %{
      temperature: get_in(payload, ["main", "temp"]) |> round(),
      desc: payload["weather"] |> hd() |> Map.get("description"),
      location: payload["name"],
      humidity: get_in(payload, ["main", "humidity"]),
      wind_speed: get_in(payload, ["wind", "speed"]),
      wind_direction: get_in(payload, ["wind", "deg"]) |> wind_direction(),
      pressure: get_in(payload, ["main", "pressure"]),
      precipitation: (payload["rain"] || %{}) |> Map.get("1h", 0),
      icon: payload["weather"] |> hd() |> Map.get("icon")
    }
  end

  defp wind_direction(deg) do
    case deg do
      d when d >= 0 and d <= 22.5 -> "N"
      d when d >= 22.5 and d <= 67.5 -> "NE"
      d when d >= 67.5 and d <= 112.5 -> "E"
      d when d >= 112.5 and d <= 157.5 -> "SE"
      d when d >= 157.5 and d <= 202.5 -> "S"
      d when d >= 202.5 and d <= 247.5 -> "SW"
      d when d >= 247.5 and d <= 292.5 -> "W"
      d when d >= 292.5 and d <= 337.5 -> "NW"
      d when d >= 337.5 and d <= 360 -> "N"
      _ -> "N"
    end
  end
end
