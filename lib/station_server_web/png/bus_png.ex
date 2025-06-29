defmodule StationServerWeb.Images.BusPNG do
  use StationServerWeb, :svg2png

  embed_templates "../templates/images/bus/*"
end
