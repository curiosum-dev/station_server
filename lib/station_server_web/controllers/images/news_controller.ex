defmodule StationServerWeb.Images.NewsController do
  use StationServerWeb, :controller

  import StationServerWeb.Links
  alias StationServerWeb.SVG2PNG
  alias StationServerWeb.Images.NewsPNG

  def show(conn, _params) do
    news_data = get_news_data()

    assigns = %{
      news_items: news_data.items,
      links: links("/news")
    }

    # Render SVG using Phoenix's normal template rendering
    svg_content = NewsPNG.show(assigns)

    case SVG2PNG.svg_to_png(svg_content) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate news image: #{reason}"})
    end
  end

  defp get_news_data do
    news_with_positions =
      [
        %{headline: "Local Election Results Announced", time_ago: "2h ago"},
        %{headline: "New Park Opens Downtown", time_ago: "4h ago"},
        %{headline: "Weather Alert: Heavy Rain Expected", time_ago: "6h ago"},
        %{headline: "City Council Meeting Scheduled", time_ago: "8h ago"}
      ]
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        Map.put(item, :y_position, 90 + index * 80)
      end)

    %{items: news_with_positions}
  end
end
