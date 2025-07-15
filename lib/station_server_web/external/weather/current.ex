defmodule StationServerWeb.External.Weather.Current do
  @openweather_api_key Application.compile_env(:station_server, :openweather_api_key)

  def get_current_weather_data do
    payload =
      Req.get!(
        "https://api.openweathermap.org/data/2.5/weather?q=Poznan,PL&units=metric&lang=pl&appid=#{@openweather_api_key}"
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
      d when d >= 0 and d <= 22.5 -> "↗️"
      d when d >= 22.5 and d <= 67.5 -> "↗️"
      d when d >= 67.5 and d <= 112.5 -> "↘️"
      d when d >= 112.5 and d <= 157.5 -> "↘️"
      d when d >= 157.5 and d <= 202.5 -> "↘️"
      d when d >= 202.5 and d <= 247.5 -> "↘️"
      d when d >= 247.5 and d <= 292.5 -> "↘️"
      d when d >= 292.5 and d <= 337.5 -> "↘️"
      d when d >= 337.5 and d <= 360 -> "↘️"
      _ -> "↗️"
    end
  end
end
