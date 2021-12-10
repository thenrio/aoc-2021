import Parsers

defmodule D9 do
  def low_points(matrix) do
    size = {n, m} = Matrix.size(matrix)

    for i <- 0..(n - 1), j <- 0..(m - 1) do
      {i, j}
    end
    |> Enum.reduce({[], MapSet.new(), matrix, size}, &low_points/2)
    |> elem(0)
  end

  defp low_points(ij, {lows, not_lows, matrix, size}) do
    {lows, not_lows} =
      case MapSet.member?(not_lows, ij) do
        true ->
          {lows, not_lows}

        false ->
          neighbours = Matrix.neighbours(size, ij)
          v = Matrix.value(matrix, ij)

          if Enum.all?(neighbours, fn kl -> v < Matrix.value(matrix, kl) end) do
            {[ij | lows], Enum.reduce(neighbours, not_lows, &MapSet.put(&2, &1))}
          else
            {lows, MapSet.put(not_lows, ij)}
          end
      end

    {lows, not_lows, matrix, size}
  end
end

matrix =
  IO.binstream(:stdio, :line)
  |> Enum.map(&to_codepoints_to_ints/1)

D9.low_points(matrix)
|> IO.inspect()
