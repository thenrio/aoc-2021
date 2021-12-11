defmodule Grid do
  @moduledoc """
  Implicit graph, uses lists.
  There is no implicit graph in bitwalker/libgraph...
  """
  defstruct grid: [], size: 0

  def new(grid) do
    %Grid{grid: grid, size: size(grid)}
  end

  defp size(grid) do
    [head | _tail] = grid
    {length(grid), length(head)}
  end

  def value(%Grid{grid: grid}, {i, j}) do
    grid |> Enum.at(i) |> Enum.at(j)
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
