defmodule D10 do
  @open ["(", "[", "{", "<"]

  @close [")", "]", "}", ">"]

  @closing %{
    ")" => "(",
    "]" => "[",
    "}" => "{",
    ">" => "<"
  }

  @score %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  def parse(line) do
    line
    |> String.trim_trailing()
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce_while({:ok, []}, fn
      {o, _i}, {:ok, stack} when o in @open -> 
        {:cont, {:ok, [o | stack]}}
      {c, i}, {:ok, [o | stack]} when c in @close ->
        case Map.get(@closing, c) do
          ^o -> {:cont, {:ok, stack}}
          x -> {:halt, {:error, c, i, x}}
        end
      {c, i}, _ ->
        {:halt, {:error, c, i, :illegal}}
    end)
  end

  def score({{:error, c, _i, _hint}, _line}), do: Map.get(@score, c)
end

IO.binstream(:stdio, :line)
|> Stream.map(&D10.parse/1)
|> Stream.zip(Stream.iterate(0, &(&1 + 1)))
|> Stream.filter(fn
  {{:error, _c, _i, _hint}, _line} -> true
  _ -> false
end)
|> Stream.map(&D10.score/1)
|> Enum.frequencies()
|> Enum.map(fn {k, v} -> k * v end)
|> Enum.sum()
|> IO.inspect()
