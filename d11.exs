import Parsers

defmodule D11 do
  def tick(_i, {grid, count}) do
    {grid, set} =
      grid
      |> age()
      |> flash()

    n = count + MapSet.size(set)
    {reset(set, grid), n}
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

  def reduce_while_tick_sync(grid, max) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(grid, fn i, grid ->
      sum = grid |> Grid.values() |> Enum.sum()

      case sum do
        0 ->
          {:halt, i}

        _otherwise ->
          case i < max do
            true -> {:cont, tick(i, {grid, 0}) |> elem(0)}
            false -> {:halt, {:error, max}}
          end
      end
    end)
  end
end

grid =
  IO.binstream(:stdio, :line)
  |> Enum.map(&to_codepoints_to_ints/1)
  |> Grid.new()

n = System.get_env("N", "100") |> String.to_integer()
max = System.get_env("MAX", "1000") |> String.to_integer()

1..n
|> Enum.reduce({grid, 0}, &D11.tick/2)
|> tap(fn {grid, m} ->
  IO.puts("tick: #{n}, #{m} flashs")
  grid |> Grid.ascii() |> IO.puts()
end)

D11.reduce_while_tick_sync(grid, max)
|> IO.inspect(label: "part 2")
