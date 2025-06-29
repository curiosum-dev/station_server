defmodule StationServerWeb.Images.NewsPNG do
  use StationServerWeb, :svg2png

  embed_svg2png_templates("templates/news/*", [:show])
end
