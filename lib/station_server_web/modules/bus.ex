defmodule StationServerWeb.Modules.Bus do
  use StationServerWeb.AppModule

  @stops [
    %{name: "Czarnucha", id: "pl-Poznań_4396"},
    %{name: "Os. Łokietka", id: "pl-Poznań_456"},
    %{name: "Rubież", id: "pl-Poznań_454"},
    %{name: "Naramowice", id: "pl-Poznań_4013"}
  ]

  @impl true
  def name, do: "MPK"

  @impl true
  def path, do: "/bus"

  @impl true
  def image_path(assigns) do
    "/images/bus.png?stop_name=#{URI.encode(assigns[:stop_name])}&stop_id=#{URI.encode(assigns[:stop_id])}"
  end

  @impl true
  def page_data do
    %{
      refresh_every: 60_000
    }
  end

  @impl true
  def extra_links(assigns) do
    stops = Enum.filter(@stops, fn stop -> stop.id != assigns[:stop_id] end)

    stops
    |> Enum.with_index()
    |> Enum.map(fn {stop, index} ->
      x1 = index * (600 / Enum.count(stops))
      x2 = x1 + 600 / Enum.count(stops)

      coords_begin = {x1, 0}
      coords_end = {x2, 100}

      {stop.name,
       %{
         begin: coords_begin,
         end: coords_end,
         url: "/bus?stop_name=#{URI.encode(stop.name)}&stop_id=#{URI.encode(stop.id)}"
       }}
    end)
    |> Map.new()
  end

  def stops do
    @stops
  end
end
