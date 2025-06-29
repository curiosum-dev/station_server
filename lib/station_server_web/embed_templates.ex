defmodule StationServerWeb.EmbedTemplates do
  defmacro embed_svg2png_templates(str, templates) do
    defoverridables =
      Enum.map(templates, fn template ->
        quote do
          defoverridable [{unquote(template), 1}]
        end
      end)

    functions =
      Enum.map(templates, fn template ->
        quote do
          def unquote(template)(assigns) do
            case super(assigns)
                 |> StationServerWeb.SVG2PNG.svg_to_png() do
              {:ok, png_data} ->
                png_data

              {:error, reason} ->
                {:error, "Failed to convert SVG to PNG: #{reason}"}
            end
          end
        end
      end)

    quote do
      embed_templates unquote(str)

      unquote(defoverridables)

      unquote(functions)
    end
  end
end
