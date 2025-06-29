defmodule StationServerWeb.Images.TodoPNG do
  use StationServerWeb, :svg2png

  embed_templates "templates/todo/*"
end
