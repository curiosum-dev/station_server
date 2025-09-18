defmodule StationServerWeb.Pages.BusController do
  use StationServerWeb, :controller

  @default_stop %{name: "Czarnucha", id: "pl-Poznań_4462"}

  def index(conn, params) do
    stop_name = params["stop_name"] || @default_stop.name
    stop_id = params["stop_id"] || @default_stop.id

    conn
    |> assign(:stop_name, stop_name)
    |> assign(:stop_id, stop_id)
    |> render(:index)
  end
end
