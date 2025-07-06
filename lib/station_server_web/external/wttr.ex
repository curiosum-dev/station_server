defmodule StationServerWeb.External.Wttr do
  @spec get_wttr_png_binary() :: binary() | no_return()
  def get_wttr_png_binary do
    Req.get!("https://pl.wttr.in/poznan.png?0pqn").body
    # |> Vix.Vips.Image.new_from_buffer()
    # |> then(fn {:ok, image} -> image end)
    # |> Vix.Vips.Operation.invert!()
    # |> Vix.Vips.Image.write_to_buffer(".png")
    # |> then(fn {:ok, buffer} -> buffer end)
  end
end
