defmodule StationServerWeb.Images.BusController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  @stops [
    %{name: "Os. Łokietka", id: "pl-Poznań_456"},
    %{name: "Rubież", id: "pl-Poznań_454"},
    %{name: "Naramowice", id: "pl-Poznań_4013"},
    %{name: "Jasna Rola", id: "pl-Poznań_4009"}
  ]

  @default_stop %{name: "Os. Łokietka", id: "pl-Poznań_456"}

  def show(conn, params) do
    stop_name = params["stop_name"] || @default_stop.name
    stop_id = params["stop_id"] || @default_stop.id

    {:ok, routes} =
      StationServerWeb.External.Transit.Departures.get_departures(stop_id, 50)

    assigns = %{
      links: AppModule.links(StationServerWeb.Modules.Bus),
      current_stop: %{name: stop_name, id: stop_id},
      current_time:
        NaiveDateTime.local_now()
        |> NaiveDateTime.to_time()
        |> to_string()
        |> String.split(":")
        |> Enum.take(2)
        |> Enum.join(":"),
      stops:
        @stops
        |> Enum.filter(fn stop -> stop.id != stop_id end),
      routes: routes
    }

    conn
    |> render(assigns)
  end

  # defp links(stop_id) do
  #   @stops
  #   |> Enum.map(fn stop ->
  #     %{
  #       name: stop.name,
  #       id: stop.id,
  #       url: "/images/bus?stop_name=#{stop.name}&stop_id=#{stop.id}"
  #     }
  #   end)
  #   |> Enum.filter(fn stop -> stop.id != stop_id end)
  # end
end
