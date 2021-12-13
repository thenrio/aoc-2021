import Parsers

defmodule D11 do
  @dx -1..1
  def neighbors(%Grid{size: {n, m}}, {i, j}) do
    for {di, dj} <- Enum.product([@dx, @dx]),
        ni = i + di,
        nj = j + dj,
        ni >= 0 and ni < n,
        nj >= 0 and nj < m,
        ni != i and nj != j do
      {ni, nj}
    end
  end

  def tick(_i, {grid, count}) do
    {grid, flash} =
      grid
      |> age()
      |> flash()

    {grid, count + flash}
  end

  def age(g = %Grid{grid: grid}) do
    Enum.reduce(grid, {g, MapSet.new()}, fn {ij, val}, {acc, flashs} ->
      val = val + 1
      acc = Grid.put(acc, ij, val)

      case val >= 9 do
        true -> {acc, MapSet.put(flashs, ij)}
        false -> {acc, flashs}
      end
    end)
  end

  def flash({grid, _flashs}) do
    {grid, 0}
  end
end

grid =
  IO.binstream(:stdio, :line)
  |> Enum.map(&to_codepoints_to_ints/1)
  |> Grid.new()

n = System.get_env("N", "100") |> String.to_integer()

1..n
|> Enum.reduce({grid, 0}, &D11.tick/2)
