defmodule D13 do
  # Are you serious? a dot is #??
  @dot "#"
  @not_a_dot "."

  @spec parse(Enumerable.t) :: {%Grid{}, list()}
  def parse(stream) do
    {_state, grid, n, m, instructions} = Enum.reduce(stream, {:grid, %Grid{}, 0, 0, []}, &parse/2)
    {fill(grid, n, m), Enum.reverse(instructions)}
  end

  defp parse("", {:grid, grid, n, m, []}) do
    {:instructions, grid, n, m, []}
  end

  defp parse(line, {:grid, grid, n, m, []}) do
    [x, y] = line |> String.split(",") |> Enum.map(&String.to_integer/1)
    {:grid, Grid.put(grid, {y, x}, @dot), max(y, n), max(x, m), []}
  end

  defp parse(<<"fold along y=", rest::binary>>, {:instructions, grid, n, m, instructions}) do
    {:instructions, grid, n, m, [{:y, String.to_integer(rest)} | instructions]}
  end

  defp parse(<<"fold along x=", rest::binary>>, {:instructions, grid, n, m, instructions}) do
    {:instructions, grid, n, m, [{:x, String.to_integer(rest)} | instructions]}
  end

  defp fill(grid, n, m) do
    keys = Grid.keys(grid)

    grid =
      for(i <- 0..n, j <- 0..m, do: {i, j})
      |> Stream.reject(&Enum.member?(keys, &1))
      |> Enum.reduce(grid, &Grid.put(&2, &1, @not_a_dot))

    %{grid | size: {n + 1, m + 1}}
  end

  @spec fold(instruction :: any, grid :: %Grid{}) :: %Grid{}
  def fold({:y, y}, %Grid{grid: grid, size: size}) do
    {n, m} = size
    grid = Map.filter(grid, fn {{i, _j}, _v} -> i < y end)
    %Grid{grid: grid, size: {y - 1, m}}
  end

  def dot?(value), do: value == @dot
end

{grid, instructions} = IO.binstream(:stdio, :line)
|> Stream.map(&String.trim_trailing/1)
|> D13.parse()
|> tap(fn {grid, instructions} ->
  IO.puts(Grid.ascii(grid))
  IO.inspect(instructions, label: "instructions")
end)

instructions
|> Enum.take(1)
|> Enum.reduce(grid, &D13.fold/2) 
|> tap(fn grid ->
  grid |> Grid.ascii() |> IO.puts()
  IO.puts(grid.size)
end) 
|> Grid.values()
|> Enum.count(&D13.dot?/1)
|> IO.inspect(label: "part 1")
