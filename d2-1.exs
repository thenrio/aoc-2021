defmodule D2 do
  def parse(<<"forward ", rest::binary>>), do: {:x, :+, parse_int(rest)}
  def parse(<<"down ", rest::binary>>), do: {:y, :+, parse_int(rest)}
  def parse(<<"up ", rest::binary>>), do: {:y, :-, parse_int(rest)}

  defp parse_int(string), do: Integer.parse(string) |> elem(0)

  def apply({:x, op, z}, {x, y}), do: {:erlang.apply(:erlang, op, [x, z]), y}
  def apply({:y, op, z}, {x, y}), do: {x, :erlang.apply(:erlang, op, [y, z])}
end

{x, y} =
  IO.binstream(:stdio, :line)
  |> Stream.map(&D2.parse/1)
  |> Enum.reduce({0, 0}, &D2.apply/2)

IO.inspect(x * y)
