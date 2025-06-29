defmodule StationServerWeb.ImageController do
  use StationServerWeb, :controller
  import StationServerWeb.Links

  def weather(conn, _params) do
    weather_data = get_weather_data()

    assigns = %{
      temperature: weather_data.temperature,
      condition: weather_data.condition,
      location: weather_data.location,
      updated_at: format_time(weather_data.updated_at),
      links: links("/")
    }

    case render_svg_to_png("weather.svg.eex", assigns) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate weather image: #{reason}"})
    end
  end

  def bus(conn, _params) do
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

  def news(conn, _params) do
    news_data = get_news_data()

    # Prepare news items with positioning
    news_with_positions =
      news_data.items
      |> Enum.take(4)
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        Map.put(item, :y_position, 90 + index * 80)
      end)

    assigns = %{
      news_items: news_with_positions,
      links: links("/news")
    }

    case render_svg_to_png("news.svg.eex", assigns) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate news image: #{reason}"})
    end
  end

  def todo(conn, _params) do
    assigns = %{
      links: links("/todo")
    }

    case render_svg_to_png("todo.svg.eex", assigns) do
      {:ok, png_data} ->
        conn
        |> put_resp_content_type("image/png")
        |> put_resp_header("cache-control", "public, max-age=30")
        |> send_resp(200, png_data)

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to generate todo image: #{reason}"})
    end
  end

  # Private functions for rendering SVG to PNG
  defp render_svg_to_png(template_name, assigns) do
    # Use a simpler path resolution approach
    template_path =
      Path.join([
        File.cwd!(),
        "lib",
        "station_server_web",
        "templates",
        "images",
        template_name
      ])

    # Debug output to help troubleshoot
    IO.puts("Looking for template at: #{template_path}")
    IO.puts("Template exists: #{File.exists?(template_path)}")

    if File.exists?(template_path) do
      # try do
      # Render the SVG template
      svg_content =
        EEx.eval_file(template_path, assigns: assigns) |> IO.inspect(label: "svg_content")

      # Convert iodata to binary for Resvg
      svg_binary = IO.iodata_to_binary(svg_content)
      IO.puts("SVG content generated successfully, length: #{String.length(svg_binary)}")

      # Convert SVG to PNG using Resvg
      case Resvg.svg_string_to_png_buffer(svg_binary, resources_dir: "/tmp") do
        {:ok, png_data} ->
          IO.puts("PNG conversion successful, size: #{length(png_data)}")
          {:ok, png_data}

        {:error, reason} ->
          IO.puts("PNG conversion failed: #{reason}")
          {:error, "Failed to render SVG: #{reason}"}
      end
    else
      {:error, "Template not found at: #{template_path}"}
    end
  end

  # Data fetching functions (same as in PageController)
  defp get_weather_data do
    %{
      temperature: 22,
      condition: "Partly Cloudy",
      location: "Downtown",
      updated_at: DateTime.utc_now()
    }
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

  defp get_news_data do
    %{
      items: [
        %{headline: "Local Festival This Weekend", time_ago: "2h ago"},
        %{headline: "New Bike Lanes Open Downtown", time_ago: "4h ago"},
        %{headline: "Weather Alert: Rain Expected", time_ago: "6h ago"}
      ]
    }
  end

  defp format_time(datetime) do
    Calendar.strftime(datetime, "%H:%M")
  end
end
