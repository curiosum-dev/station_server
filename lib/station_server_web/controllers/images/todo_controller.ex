defmodule StationServerWeb.Images.TodoController do
  use StationServerWeb, :controller

  import StationServerWeb.Links
  alias StationServerWeb.SVG2PNG

  def show(conn, _params) do
    assigns = %{
      links: links("/todo")
    }

    case SVG2PNG.render_svg_to_png("todo.svg.eex", assigns) do
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
