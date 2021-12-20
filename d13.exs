defmodule D13 do
  # Are you serious? a dot is #??
  @dot "#"

  @spec parse(Enumerable.t()) :: {%Grid{}, list()}
  def parse(stream) do
    {_state, grid, n, m, instructions} = Enum.reduce(stream, {:grid, %{}, 0, 0, []}, &parse/2)
    {%Grid{grid: grid, size: {n + 1, m + 1}, default: "."}, Enum.reverse(instructions)}
  end

  defp parse("", {:grid, grid, n, m, []}) do
    {:instructions, grid, n, m, []}
  end

  defp parse(line, {:grid, grid, n, m, []}) do
    [x, y] = line |> String.split(",") |> Enum.map(&String.to_integer/1)
    {:grid, Map.put(grid, {y, x}, @dot), max(y, n), max(x, m), []}
  end

  defp parse(<<"fold along y=", rest::binary>>, {:instructions, grid, n, m, instructions}) do
    {:instructions, grid, n, m, [{:y, String.to_integer(rest)} | instructions]}
  end

  defp parse(<<"fold along x=", rest::binary>>, {:instructions, grid, n, m, instructions}) do
    {:instructions, grid, n, m, [{:x, String.to_integer(rest)} | instructions]}
  end

  @spec fold(instruction :: any, grid :: %Grid{}) :: %Grid{}
  def fold({:y, y}, grid) do
    %Grid{grid: g, size: {_n, m}} = grid
    # This is an assert?
    # n = 2 * y + 1
    g =
      Enum.reduce(g, %{}, fn
        {ij = {i, _j}, val}, g when i < y -> Map.put_new(g, ij, val)
        {{i, j}, val}, g when i > y -> Map.put_new(g, {2 * y - i, j}, val)
        _, g -> g
      end)

    %{grid | grid: g, size: {y, m}}
  end

  def fold({:x, x}, grid) do
    %Grid{grid: g, size: {n, _m}} = grid
    g =
      Enum.reduce(g, %{}, fn
        {ij = {_i, j}, val}, g when j < x -> Map.put_new(g, ij, val)
        {{i, j}, val}, g when j > x -> Map.put_new(g, {i, 2 * x - j}, val)
        _, g -> g
      end)

    %{grid | grid: g, size: {n, x}}
  end

  def print(grid) do
    grid |> Grid.ascii() |> IO.puts()
  end
end

{grid, instructions} =
  IO.binstream(:stdio, :line)
  |> Stream.map(&String.trim_trailing/1)
  |> D13.parse()

n = System.get_env("N", "1") |> String.to_integer()
debug? = System.get_env("DEBUG", "0") |> String.to_integer() > 0

instructions
|> Enum.take(n)
|> Enum.reduce(grid, &D13.fold/2)
|> tap(fn g -> if debug?, do: D13.print(g) end)
|> Grid.values()
|> Enum.count()
|> IO.inspect(label: "part 1")
