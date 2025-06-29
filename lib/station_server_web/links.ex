defmodule StationServerWeb.Links do
  def links("/") do
    %{"MPK" => "/bus", "News" => "/news", "Todo" => "/todo"}
  end

  def links("/bus") do
    %{"Weather" => "/", "News" => "/news", "Todo" => "/todo"}
  end

  def links("/news") do
    %{"Weather" => "/", "MPK" => "/bus", "Todo" => "/todo"}
  end

  def links("/todo") do
    %{"Weather" => "/", "MPK" => "/bus", "News" => "/news"}
  end

  def links_to_touch_regions(links) do
    link_width = 600 / Enum.count(links)

    links
    |> Enum.with_index()
    |> Enum.map(fn {{_link_text, link_url}, index} ->
      %{
        begin: [index * link_width, 500],
        end: [index * link_width + link_width, 600],
        url: link_url
      }
    end)
  end
end
