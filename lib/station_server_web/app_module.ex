defmodule StationServerWeb.AppModule do
  @type page_data :: %{optional(:refresh_every) => pos_integer()}

  @callback name() :: String.t()
  @callback path() :: String.t()
  @callback page_data() :: page_data()

  def modules do
    [
      StationServerWeb.Modules.Weather,
      StationServerWeb.Modules.Bus,
      StationServerWeb.Modules.News,
      StationServerWeb.Modules.Todo
    ]
  end

  def links(module) do
    modules()
    |> Stream.filter(fn m -> m != module end)
    |> Stream.map(fn m -> {m.name(), m.path()} end)
    |> Map.new()
  end

  def payload(module) do
    %{
      picture: "/images/#{module.path()}.png",
      touch: links(module) |> links_to_touch_regions()
    }
    |> Map.merge(module.page_data())
  end

  defp links_to_touch_regions(links) do
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
