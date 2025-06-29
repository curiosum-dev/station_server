defmodule StationServerWeb.Images.SVG2PNG do
  def render_svg_to_png(template_name, assigns) do
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
end
