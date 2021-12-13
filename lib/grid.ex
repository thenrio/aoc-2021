defmodule Grid do
  @moduledoc """
  Implicit graph, uses lists.
  There is no implicit graph in bitwalker/libgraph...
  """
  defstruct grid: %{}, size: {0, 0}

  def new(grid) do
    %Grid{grid: to_map(grid), size: size(grid)}
  end

  defp size(grid) do
    [head | _tail] = grid
    {length(grid), length(head)}
  end

  def to_map(grid) do
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

  def get(%Grid{grid: grid}, ij) do
    Map.get(grid, ij)
  end

  def put(g = %Grid{grid: grid}, ij, val) do
    %{g | grid: Map.put(grid, ij, val)}
  end

  def neighbors(%Grid{size: {n, m}}, {i, j}) do
    for {di, dj} <- [{-1, 0}, {1, 0}, {0, -1}, {0, 1}],
        ni = i + di,
        nj = j + dj,
        ni >= 0 and ni < n,
        nj >= 0 and nj < m do
      {ni, nj}
    end
  end
end
