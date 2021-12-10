defmodule Matrix do
  def size(matrix) do
    [head | _tail] = matrix
    {length(matrix), length(head)}
  end

  def value(matrix, {i, j}) do
    matrix |> Enum.at(i) |> Enum.at(j)
  end

  def neighbours({n, m}, {i, j}) do
    for {di, dj} <- [{-1, 0}, {1, 0}, {0, -1}, {0, 1}],
        ni = i + di,
        nj = j + dj,
        ni >= 0 and ni < n,
        nj >= 0 and nj < m do
      {ni, nj}
    end
  end
end
