defmodule StationServerWeb.PageJSON do
  import StationServerWeb.Links

  def index(_params \\ %{}) do
    %{
      picture: "/images/weather.png",
      refresh_every: 30_000,
      touch: links("/") |> links_to_touch_regions()
    }
  end

  def bus(_params \\ %{}) do
    %{
      picture: "/images/bus.png",
      refresh_every: 30_000,
      touch: links("/bus") |> links_to_touch_regions()
    }
  end

  def news(_params \\ %{}) do
    %{
      picture: "/images/news.png",
      refresh_every: 30_000,
      touch: links("/news") |> links_to_touch_regions()
    }
  end

  def todo(_params \\ %{}) do
    %{
      picture: "/images/todo.png",
      refresh_every: 30_000,
      touch: links("/todo") |> links_to_touch_regions()
    }
  end
end
