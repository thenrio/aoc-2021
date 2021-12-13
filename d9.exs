import Parsers

defmodule D9 do
  def low_points(grid) do
    {n, m} = grid.size

    for i <- 0..(n - 1), j <- 0..(m - 1) do
      {i, j}
    end
    |> Enum.reduce({[], MapSet.new(), grid}, &low_point/2)
    |> elem(0)
  end

  defp low_point(ij, {lows, not_lows, grid}) do
    {lows, not_lows} =
      case MapSet.member?(not_lows, ij) do
        true ->
          {lows, not_lows}

        false ->
          neighbors = Grid.neighbors(grid, ij)
          v = Grid.get(grid, ij)

          if Enum.all?(neighbors, fn kl -> v < Grid.get(grid, kl) end) do
            {[{ij, v} | lows], Enum.reduce(neighbors, not_lows, &MapSet.put(&2, &1))}
          else
            {lows, MapSet.put(not_lows, ij)}
          end
      end

    {lows, not_lows, grid}
  end

  def basin(ijv, grid) do
    basin([ijv], grid, MapSet.new(), [])
  end

  defp basin([{ij, v} | rest], grid, visited, basin) do
    case ij in visited do
      true ->
        basin(rest, grid, visited, basin)

      false ->
        neighbors =
          for kl <- Grid.neighbors(grid, ij),
              kl not in visited,
              w = Grid.get(grid, kl),
              w >= v and w < 9,
              do: {kl, w}

        basin(rest ++ neighbors, grid, MapSet.put(visited, ij), [ij | basin])
    end
  end

  defp basin([], _grid, _visited, basin), do: basin
end

grid =
  IO.binstream(:stdio, :line)
  |> Enum.map(&to_codepoints_to_ints/1)
  |> Grid.new()

low_points = D9.low_points(grid)

low_points
|> Stream.map(&(elem(&1, 1) + 1))
|> Enum.sum()
|> IO.inspect(label: "part 1")

[a, b, c] =
  low_points
  |> Stream.map(&D9.basin(&1, grid))
  |> Stream.map(&length/1)
  |> Enum.sort(:desc)
  |> Enum.take(3)

IO.inspect(a * b * c, label: "part 2")
