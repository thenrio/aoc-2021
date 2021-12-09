defmodule Parsers do
  def to_codepoints_to_ints(line) do
    line
    |> String.trim_trailing()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end
end
