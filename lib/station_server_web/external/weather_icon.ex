defmodule StationServerWeb.External.WeatherIcon do
  @spec get_weather_icon_binary(String.t(), String.t()) :: binary() | no_return()
  def get_weather_icon_binary(code, size \\ "") do
    Req.get!("https://openweathermap.org/img/wn/#{code}#{size}.png").body
  end
end
