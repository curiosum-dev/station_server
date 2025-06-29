defmodule StationServerWeb.Images.WeatherPNG do
  use StationServerWeb, :svg2png

  embed_svg2png_templates("templates/weather/*", [:show])
end
