defmodule StationServerWeb.Images.NewsController do
  use StationServerWeb, :controller

  import StationServerWeb.Links
  import StationServerWeb.Images.SVG2PNG

  def show(conn, _params) do
    news_data = get_news_data()

    # Prepare news items with positioning
    news_with_positions =
      news_data.items
      |> Enum.take(4)
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        Map.put(item, :y_position, 90 + index * 80)
      end)

    assigns = %{
      news_items: news_with_positions,
      links: links("/news")
    }

    case render_svg_to_png("news.svg.eex", assigns) do
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
    %{
      items: [
        %{headline: "Local Festival This Weekend", time_ago: "2h ago"},
        %{headline: "New Bike Lanes Open Downtown", time_ago: "4h ago"},
        %{headline: "Weather Alert: Rain Expected", time_ago: "6h ago"}
      ]
    }
  end
end
