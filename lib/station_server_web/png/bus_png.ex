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

  defp stops_navigation_bar(stops) do
    for {stop, index} <-
          stops
          |> Enum.with_index() do
      """
        <g>
          <rect x="#{index * 600 / length(stops)}" y="0" width="#{600 / length(stops)}" height="100" style="fill:rgb(186,186,186);stroke:black;stroke-width:1.21px;"/>
          <text x="#{(index + 0.5) * 600 / length(stops)}" y="60" style="text-anchor: middle; font-family: 'Arial', sans-serif;font-weight:700;font-size:27px;">#{stop.name}</text>
        </g>
      """
    end
  end

  defp route_departures_rows(routes) do
    for {route, index} <-
          routes
          |> Enum.with_index() do
      """
        <g transform="matrix(0.7,0,0,0.7,-15,#{65 + index * 40})">
          <g transform="matrix(0.75,0,0,0.75,-130,-165)">
            <circle cx="240" cy="395" r="26"/>
          </g>
          <g transform="matrix(2.2,0,0,2.2,15,-755)">
            <text x="16" y="406" style="font-family:'Arial', sans-serif;font-size:10px;fill:white;text-anchor: middle;">#{route[:route_id]}</text>
          </g>
          <g transform="matrix(1.56655,0,0,1.56655,-125,-48)">
            <text x="130" y="120" style="font-family:'Arial', sans-serif;font-size:17px;"><tspan style="font-weight:700">#{route[:headsign]}</tspan> #{route[:departures] |> format_departures()}</text>
          </g>
        </g>
      """
    end
  end
end
