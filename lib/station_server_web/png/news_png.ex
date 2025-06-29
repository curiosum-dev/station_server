defmodule StationServerWeb.Images.NewsPNG do
  use StationServerWeb, :svg2png

  embed_templates "../templates/images/news/*"
end
