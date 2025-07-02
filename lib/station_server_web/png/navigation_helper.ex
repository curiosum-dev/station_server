defmodule StationServerWeb.PNG.NavigationHelper do
  @moduledoc """
  Helper functions for generating common SVG elements used in PNG templates.
  """

  @doc """
  Generates the navigation bar SVG content for the bottom of the image.
  """
  def navigation_bar(links) do
    links
    |> Enum.with_index()
    |> Enum.map(fn {{link_text, _link_url}, index} ->
      width = 600 / Enum.count(links)
      x_position = index * width
      text_x = (index + 0.45) * width + 10

      """
      <g>
        <rect width="#{width}" height="100" x="#{x_position}" y="500" fill="#9ca3af" stroke="#000000" />
        <text x="#{text_x}" y="560" fill="black" font-weight="bold" font-family="Arial, sans-serif" font-size="32" text-anchor="middle">
          #{xml_escape(link_text)}
        </text>
      </g>
      """
    end)
    |> Enum.join("\n    ")
  end

  defp xml_escape(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&#39;")
  end
end
