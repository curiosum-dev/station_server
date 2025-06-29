defmodule StationServerWeb.Pages.BusJSON do
  import StationServerWeb.Links

  def index(_params \\ %{}) do
    %{
      picture: "/images/bus.png",
      refresh_every: 30_000,
      touch: links("/bus") |> links_to_touch_regions()
    }
  end
end
