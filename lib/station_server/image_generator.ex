defmodule StationServer.ImageGenerator do
  @moduledoc """
  Generates PNG images from SVG templates
  """

  def generate_weather_image(weather_data) do
    assigns = %{
      temperature: weather_data.temperature,
      condition: weather_data.condition,
      location: weather_data.location,
      updated_at: format_time(weather_data.updated_at)
    }

    render_template("weather.svg.eex", assigns)
  end

  def generate_bus_image(bus_data) do
    assigns = %{
      routes: bus_data.routes
    }

    render_template("bus.svg.eex", assigns)
  end

  def generate_news_image(news_data) do
    news_with_positions =
      news_data.items
      |> Enum.take(4)
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        Map.put(item, :y_position, 90 + index * 80)
      end)

    assigns = %{
      news_items: news_with_positions
    }

    render_template("news.svg.eex", assigns)
  end

  defp render_template(template_name, assigns) do
    # Render the SVG template
    svg_content =
      template_name
      |> template_path()
      |> EEx.eval_file(assigns: assigns)

    # Convert SVG to PNG using Resvg
    case Resvg.svg_string_to_png_buffer(svg_content, resources_dir: "/tmp") do
      {:ok, png_data} -> {:ok, png_data}
      {:error, reason} -> {:error, "Failed to render SVG: #{reason}"}
    end
  end

  defp template_path(template_name) do
    Path.join([
      Application.app_dir(:station_server),
      "priv",
      "templates",
      "images",
      template_name
    ])
  end

  defp format_time(datetime) do
    Calendar.strftime(datetime, "%H:%M")
  end
end
