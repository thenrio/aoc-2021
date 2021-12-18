import Parsers

defmodule D11 do
  def tick(i, {grid, count}) do
    {grid, set} =
      grid
      |> age()
      |> flash()

    n = count + MapSet.size(set)

    {reset(set, grid), n}
    |> tap(fn {grid, n} ->
      IO.puts("tick: #{i}, #{n} flashs")
      grid |> Grid.ascii() |> IO.puts()
    end)
  end

  @spec age(%Grid{}) :: {%Grid{}, list()}
  defp age(grid) do
    Enum.reduce(Grid.keys(grid), {grid, []}, fn ij, {acc, list} ->
      {acc, val} = age(acc, ij)

      case val > 9 do
        true -> {acc, [ij | list]}
        false -> {acc, list}
      end
    end)
  end

  defp age(grid, ij) do
    value = Grid.get(grid, ij) + 1
    {Grid.put(grid, ij, value), value}
  end

  defp flash({grid, list}) do
    flash(list, MapSet.new(list), grid)
  end

  defp flash([ij | rest], set, grid) do
    {list, set, grid} =
      Enum.reduce(Grid.neighbors(grid, ij, :queen), {[], set, grid}, fn kl, {list, set, grid} ->
        {grid, val} = age(grid, kl)

        case val > 9 and kl not in set do
          true ->
            {[kl | list], MapSet.put(set, kl), grid}

          false ->
            {list, set, grid}
        end
      end)

    flash(rest ++ list, set, grid)
  end

  defp flash([], set, grid), do: {grid, set}

  defp reset(set, grid) do
    Enum.reduce(set, grid, &Grid.put(&2, &1, 0))
  end
end

grid =
  IO.binstream(:stdio, :line)
  |> Enum.map(&to_codepoints_to_ints/1)
  |> Grid.new()
  |> tap(fn g -> g |> Grid.ascii() |> IO.puts() end)

# correct response of test input is 1656, number of flashs
n = System.get_env("N", "100") |> String.to_integer()

1..n
|> Enum.reduce({grid, 0}, &D11.tick/2)
