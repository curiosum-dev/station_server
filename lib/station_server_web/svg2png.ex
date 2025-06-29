defmodule StationServerWeb.SVG2PNG do
  @moduledoc """
  Converts already-rendered SVG content to PNG using Resvg.
  Works with Phoenix-rendered templates, no manual EEx evaluation needed.
  """

  @doc """
  Converts rendered SVG content to PNG.
  """
  def svg_to_png(svg_content) when is_binary(svg_content) do
    case Resvg.svg_string_to_png_buffer(svg_content, resources_dir: "/tmp") do
      {:ok, png_data} ->
        {:ok, png_data}

      {:error, reason} ->
        {:error, "Failed to render SVG to PNG: #{reason}"}
    end
  end

  def svg_to_png(svg_iodata) do
    svg_content = IO.iodata_to_binary(svg_iodata)
    svg_to_png(svg_content)
  end
end
