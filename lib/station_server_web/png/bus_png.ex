defmodule StationServerWeb.Images.BusPNG do
  use StationServerWeb, :svg2png

  embed_svg2png_templates("templates/bus/*", [:show])
end
