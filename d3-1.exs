# mix run d3-1.exs <inputs/d3
use Bitwise

import Parsers

{sums, length} =
  IO.binstream(:stdio, :line)
  |> Stream.map(&to_codepoints_to_ints/1)
  |> Enum.reduce(nil, fn
    bits, nil ->
      {bits, 1}

    bits, {sums, n} ->
      {Enum.zip(bits, sums) |> Enum.map(fn {i, j} -> i + j end), n + 1}
  end)

mid = div(length, 2)

gamma =
  Enum.map(sums, fn
    n when n >= mid -> 1
    _n -> 0
  end)
  |> Enum.join("")
  |> String.to_integer(2)

# There is no unsigned integer...
epsilon =
  gamma
  |> bnot()
  |> band(Integer.pow(2, length(sums)) - 1)

(gamma * epsilon)
|> IO.inspect()
