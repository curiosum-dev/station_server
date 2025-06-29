defmodule StationServerWeb.Images.WeatherPNG do
  use StationServerWeb, :svg2png

  embed_templates "templates/weather/*"
end
