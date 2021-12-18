defmodule GridTest do
  use ExUnit.Case, async: true

  defp parse_int_grid(path) do
    File.stream!(path)
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&Parsers.to_codepoints_to_ints/1)
    |> Grid.new()
  end

  test "parse" do
    grid = parse_int_grid("test/inputs/d9")
    assert Grid.get(grid, {0, 0}) == 2
  end

  test "neighbors" do
    grid = parse_int_grid("test/inputs/d9")
    assert Grid.neighbors(grid, {0, 0}, :manhattan) == [{1, 0}, {0, 1}]
    assert Grid.neighbors(grid, {0, 0}, :queen) == [{0, 1}, {1, 0}, {1, 1}]
  end
end
