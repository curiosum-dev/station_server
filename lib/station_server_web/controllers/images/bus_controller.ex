defmodule StationServerWeb.Images.BusController do
  use StationServerWeb, :controller

  import StationServerWeb.Links
  import StationServerWeb.Images.SVG2PNG

  def show(conn, _params) do
    bus_data = get_bus_data()

    assigns = %{
      routes: bus_data.routes,
      links: links("/bus")
    }

    case render_svg_to_png("bus.svg.eex", assigns) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate bus image: #{reason}"})
    end
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
