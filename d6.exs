defmodule D6 do
  def age(state) do
    [n | rest] = state
    List.replace_at(rest, 6, Enum.at(rest, 6) + n) ++ [n]
  end
end

state = Stream.cycle([0]) |> Enum.take(9)

state =
  IO.binstream(:stdio, :line)
  |> Enum.take(1)
  |> hd()
  |> String.trim_trailing()
  |> String.splitter(",")
  |> Stream.map(&String.to_integer/1)
  |> Enum.frequencies()
  |> Enum.reduce(state, fn {i, n}, list -> List.replace_at(list, i, n) end)

n = System.get_env("N", "80") |> String.to_integer()

Range.new(1, n)
|> Enum.reduce(state, fn _i, state -> D6.age(state) end)
|> Enum.sum()
|> IO.inspect()
