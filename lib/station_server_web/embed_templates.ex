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
            unquote(__MODULE__).convert(super(assigns))
          end
        end
      end)

    quote do
      embed_templates unquote(str)

      unquote(defoverridables)
      unquote(functions)
    end
  end

  def convert(rendered_svg) do
    case rendered_svg |> Resvg.svg_string_to_png_buffer(resources_dir: "/tmp") do
      {:ok, png_data} ->
        png_data

      error ->
        error
    end
  end
end
