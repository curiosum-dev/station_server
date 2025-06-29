defmodule StationServerWeb.Pages.NewsJSON do
  import StationServerWeb.Links

  def index(_params \\ %{}) do
    %{
      picture: "/images/news.png",
      refresh_every: 30_000,
      touch: links("/news") |> links_to_touch_regions()
    }
  end
end
