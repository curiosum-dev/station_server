defmodule StationServerWeb.Images.BusController do
  use StationServerWeb, :controller

  alias StationServerWeb.{AppModule, Modules.Bus}

  @default_stop %{name: "Czarnucha", id: "pl-Poznań_4396"}

  def show(conn, params) do
    stop_name = params["stop_name"] || @default_stop.name
    stop_id = params["stop_id"] || @default_stop.id

    {:ok, routes} =
      StationServerWeb.External.Transit.Departures.get_departures(stop_id, 50)

    assigns = %{
      links: AppModule.navigation_links(StationServerWeb.Modules.Bus),
      current_stop: %{name: stop_name, id: stop_id},
      current_time:
        NaiveDateTime.local_now()
        |> NaiveDateTime.to_time()
        |> to_string()
        |> String.split(":")
        |> Enum.take(2)
        |> Enum.join(":"),
      stops:
        Bus.stops()
        |> Enum.filter(fn stop -> stop.id != stop_id end),
      routes: routes
    }

    conn
    |> render(assigns)
  end
end
