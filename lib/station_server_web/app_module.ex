defmodule StationServerWeb.AppModule do
  @type page_data :: %{optional(:refresh_every) => pos_integer()}

  @callback name() :: String.t()
  @callback path() :: String.t()
  @callback page_data() :: page_data()
  @callback extra_links(assigns :: map()) :: %{
              required(String.t()) => %{
                required(:begin) => {number(), number()},
                required(:end) => {number(), number()},
                required(:url) => String.t() | nil
              }
            }
  @callback image_path(assigns :: map()) :: String.t()

  @optional_callbacks [extra_links: 1]

  defmacro __using__(_opts) do
    quote do
      @behaviour StationServerWeb.AppModule

      @impl true
      def extra_links(_assigns), do: %{}

      defoverridable extra_links: 1
    end
  end

  def modules do
    [
      StationServerWeb.Modules.Weather,
      StationServerWeb.Modules.Bus,
      StationServerWeb.Modules.News,
      StationServerWeb.Modules.Todo
    ]
  end

  def navigation_links(module) do
    modules()
    |> Stream.filter(fn m -> m != module end)
    |> Stream.map(fn m -> {m.name(), m.path()} end)
    |> Map.new()
  end

  def payload(module, assigns \\ %{}) do
    %{
      picture: module.image_path(assigns),
      touch:
        navigation_links(module)
        |> Map.merge(module.extra_links(assigns))
        |> links_to_touch_regions()
    }
    |> Map.merge(module.page_data())
  end

  defp links_to_touch_regions(links) do
    link_width = 600 / Enum.count(links)

    links
    |> Enum.with_index()
    |> Enum.map(fn
      {{_link_text, %{begin: coords_begin, end: coords_end, url: link_url}}, _index} ->
        %{
          begin: coords_begin,
          end: coords_end,
          url: link_url
        }

      {{_link_text, link_url}, index} ->
        %{
          begin: {index * link_width, 500},
          end: {index * link_width + link_width, 600},
          url: link_url
        }
    end)
  end
end
