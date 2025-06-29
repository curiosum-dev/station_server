defmodule StationServerWeb.Pages.TodoJSON do
  import StationServerWeb.Links

  def index(_params \\ %{}) do
    %{
      picture: "/images/todo.png",
      refresh_every: 30_000,
      touch: links("/todo") |> links_to_touch_regions()
    }
  end
end
