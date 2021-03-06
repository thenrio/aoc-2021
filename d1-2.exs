IO.binstream(:stdio, :line)
|> Stream.map(fn x -> Integer.parse(x) |> elem(0) end)
|> Stream.chunk_every(3, 1, :discard)
|> Stream.map(&Enum.sum/1)
|> Stream.chunk_every(2, 1, :discard)
|> Enum.count(fn [a, b] -> a < b end)
|> IO.inspect()
