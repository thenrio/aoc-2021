defmodule Grid do
  @moduledoc """
  Implicit graph, uses map.
  Also see bitwalker/libgraph.
  """
  defstruct default: nil, grid: %{}, size: {0, 0}

  @type t :: %Grid{
          default: any(),
          grid: map,
          size: {pos_integer, pos_integer}
        }

  @spec new(list(list)) :: Grid.t()
  @doc """
  Builds a new grid from a list of list. 
  """
  def new(grid) do
    %Grid{grid: to_map(grid), size: size(grid)}
  end

  defp size(grid) do
    [head | _tail] = grid
    {length(grid), length(head)}
  end

  defp to_map(grid) do
    grid
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, i}, grid ->
      line
      |> Enum.with_index()
      |> Enum.reduce(grid, fn {n, j}, acc ->
        Map.put(acc, {i, j}, n)
      end)
    end)
  end

  @spec get(grid :: Grid.t(), ij :: {pos_integer, pos_integer}) :: any
  def get(%Grid{grid: grid}, ij), do: get(grid, ij, grid.default)

  @spec get(grid :: Grid.t(), ij :: {pos_integer, pos_integer}, default :: any) :: any
  def get(%Grid{grid: grid}, ij, default) do
    Map.get(grid, ij, default)
  end

  @spec put(Grid.t(), {pos_integer, pos_integer}, any) :: Grid.t()
  def put(g = %Grid{grid: grid}, ij, val) do
    %{g | grid: Map.put(grid, ij, val)}
  end

  def neighbors(grid, ij, direction \\ :manhattan)

  def neighbors(%Grid{size: {n, m}}, {i, j}, :manhattan) do
    directions = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    neighbors(n, m, i, j, directions)
  end

  @dx -1..1
  def neighbors(%Grid{size: {n, m}}, {i, j}, :queen) do
    directions = for di <- @dx, dj <- @dx, di != 0 or dj != 0, do: {di, dj}
    neighbors(n, m, i, j, directions)
  end

  defp neighbors(n, m, i, j, didj) do
    for {di, dj} <- didj,
        ni = i + di,
        nj = j + dj,
        ni >= 0 and ni < n,
        nj >= 0 and nj < m do
      {ni, nj}
    end
  end

  def keys(%Grid{grid: grid}) do
    Map.keys(grid)
  end

  def values(%Grid{grid: grid}) do
    Map.values(grid)
  end

  def ascii(grid) do
    grid
    |> to_list()
    |> Stream.map(&Enum.join/1)
    |> Enum.join("\n")
  end

  defp to_list(grid) do
    {n, m} = grid.size

    for i <- 0..(n - 1) do
      for j <- 0..(m - 1) do
        get(grid, {i, j}, grid.default)
      end
    end
  end
end
