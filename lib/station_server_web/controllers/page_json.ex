defmodule StationServerWeb.PageJSON do
  def index(_params \\ %{}) do
    %{
      picture: "/images/weather.jpg",
      refresh_every: 30_000,
      touch: [
        %{begin: [0, 450], end: [300, 600], url: "/bus"},
        %{begin: [300, 450], end: [600, 600], url: "/news"}
      ]
    }
  end

  def bus(_params \\ %{}) do
    %{
      picture: "/images/bus.jpg",
      refresh_every: 30_000,
      touch: [
        %{begin: [0, 450], end: [300, 600], url: "/"},
        %{begin: [300, 450], end: [600, 600], url: "/news"}
      ]
    }
  end

  def news(_params \\ %{}) do
    %{
      picture: "/images/news.jpg",
      refresh_every: 30_000,
      touch: [
        %{begin: [0, 450], end: [300, 600], url: "/"},
        %{begin: [300, 450], end: [600, 600], url: "/bus"}
      ]
    }
  end
end
