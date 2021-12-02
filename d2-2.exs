defmodule D2 do
  def parse(<<"forward ", rest::binary>>), do: {:forward, parse_int(rest)}
  def parse(<<"down ", rest::binary>>), do: {:down, parse_int(rest)}
  def parse(<<"up ", rest::binary>>), do: {:up, parse_int(rest)}

  defp parse_int(string), do: string |> Integer.parse() |> elem(0)

  def apply({:forward, z}, {x, y, aim}), do: {x + z, y + z * aim, aim}
  def apply({:down, z}, {x, y, aim}), do: {x, y, aim + z}
  def apply({:up, z}, {x, y, aim}), do: {x, y, aim - z}
end

{x, y, _aim} =
  IO.binstream(:stdio, :line)
  |> Stream.map(&D2.parse/1)
  |> Enum.reduce({0, 0, 0}, &D2.apply/2)

IO.inspect(x * y)
