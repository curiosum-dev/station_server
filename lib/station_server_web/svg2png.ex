defmodule StationServerWeb.SVG2PNG do
  @moduledoc """
  Centralized template rendering for SVG templates.
  Uses EEx.compile_file to compile templates at build time instead of runtime.
  """

  @template_dir Path.join([File.cwd!(), "lib", "station_server_web", "templates", "images"])

  @doc """
  Renders an SVG template and converts it to PNG.
  """
  def render_svg_to_png(template_name, assigns) do
    case render_template(template_name, assigns) do
      {:error, reason} ->
        {:error, reason}

      svg_content ->
        # Convert iodata to binary for Resvg
        svg_binary = IO.iodata_to_binary(svg_content)

        # Convert SVG to PNG using Resvg
        case Resvg.svg_string_to_png_buffer(svg_binary, resources_dir: "/tmp") do
          {:ok, png_data} ->
            {:ok, png_data}

          {:error, reason} ->
            {:error, "Failed to render SVG: #{reason}"}
        end
    end
  end

  # Define template rendering functions
  defp render_template(template_name, assigns) do
    template_path = Path.join(@template_dir, template_name)

    if File.exists?(template_path) do
      EEx.eval_file(template_path, assigns: assigns)
    else
      {:error, "Template not found: #{template_path}"}
    end
  end
end
