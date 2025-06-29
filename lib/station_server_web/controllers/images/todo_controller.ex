defmodule StationServerWeb.Images.TodoController do
  use StationServerWeb, :controller

  import StationServerWeb.Links
  alias StationServerWeb.SVG2PNG
  alias StationServerWeb.Images.TodoPNG

  def show(conn, _params) do
    assigns = %{
      links: links("/todo")
    }

    # Render SVG using Phoenix's normal template rendering
    svg_content = TodoPNG.show(assigns)

    case SVG2PNG.svg_to_png(svg_content) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate todo image: #{reason}"})
    end
  end
end
