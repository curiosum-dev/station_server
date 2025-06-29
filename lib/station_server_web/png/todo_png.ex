defmodule StationServerWeb.Images.TodoPNG do
  use StationServerWeb, :svg2png

  embed_svg2png_templates("templates/todo/*", [:show])
end
