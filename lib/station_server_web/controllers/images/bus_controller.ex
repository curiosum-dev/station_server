defmodule StationServerWeb.Images.BusController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  def show(conn, _params) do
    bus_data = get_bus_data()

    assigns = %{
      routes: bus_data.routes,
      links: AppModule.links(StationServerWeb.Modules.Bus)
    }

    conn
    |> render(assigns)
  end

  defp get_bus_data do
    %{
      routes: [
        %{number: "42", destination: "City Center", next_arrival: 5},
        %{number: "15", destination: "Airport", next_arrival: 12},
        %{number: "8", destination: "University", next_arrival: 18}
      ]
    }
  end
end
