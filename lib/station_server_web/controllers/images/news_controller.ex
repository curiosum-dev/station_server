defmodule StationServerWeb.Images.NewsController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  def show(conn, _params) do
    news_data = get_news_data()

    assigns = %{
      news_items: news_data.items,
      links: AppModule.navigation_links(StationServerWeb.Modules.News)
    }

    conn
    |> render(assigns)
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
