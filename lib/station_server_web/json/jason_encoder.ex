defimpl Jason.Encoder, for: Tuple do
  def encode({x, y}, opts) when is_number(x) and is_number(y) do
    [x, y]
    |> Jason.Encode.list(opts)
  end
end
