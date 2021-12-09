import Parsers

defmodule Matrix do
  def size(matrix) do
    [head | _tail] = matrix
    {length(head), length(matrix)}
  end

  def value(matrix, {i, j}) do
    matrix |> Enum.at(i) |> Enum.at(j)
  end

  def neighbours({n, m}, {i, j}) do
    for di <- [-1, 1],
        dj <- [-1, 1],
        ni = i + di,
        nj = j + dj,
        ni >= 0 and ni < n,
        nj >= 0 and nj < m do
      {ni, nj}
    end
  end
end

defmodule D9 do
  def low_points(matrix) do
    size = {n, m} = Matrix.size(matrix)

    # I can use a bloom filter to test for exclusion?
    # Just use a map, it fits into memory :)
    not_lows = MapSet.new()

    for i <- 0..(n - 1), j <- 0..(m - 1) do
      {i, j}
    end
    |> Enum.reduce({matrix, size, [], not_lows}, &low_points/2)
    |> elem(0)
  end

  defp low_points(ij, {matrix, size, lows, not_lows}) do
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
            {lows, not_lows}
          end
          |> IO.inspect(label: "maybe low?")
      end

    {matrix, size, lows, not_lows}
  end
end

matrix =
  IO.binstream(:stdio, :line)
  |> Enum.map(&to_codepoints_to_ints/1)
  |> IO.inspect()

D9.low_points(matrix)
|> IO.inspect()
