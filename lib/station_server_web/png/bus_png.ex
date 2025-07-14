defmodule StationServerWeb.Images.BusPNG do
  use StationServerWeb, :svg2png

  embed_svg2png_templates("templates/bus/*", [:show])

  @time_zone Application.compile_env(:station_server, :default_time_zone)

  defp format_departures(departures) do
    departures
    |> Enum.map(fn departure -> departure[:departure_time] |> format_departure_time() end)
    |> Enum.join(" • ")
  end

  defp format_departure_time(departure_time) do
    {:ok, departure_time, _offset} =
      departure_time
      |> DateTime.from_iso8601()

    departure_time
    |> DateTime.shift_zone!(@time_zone)
    |> DateTime.to_time()
    |> to_string()
    |> String.split(":")
    |> Enum.take(2)
    |> Enum.join(":")
  end
end
