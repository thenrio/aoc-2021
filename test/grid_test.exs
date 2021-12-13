defmodule GridTest do
  use ExUnit.Case, async: true

  test "parse" do
    grid = File.stream!("test/inputs/d9")
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&Parsers.to_codepoints_to_ints/1)

    grid = Grid.new(grid)
    assert Grid.get(grid, {0, 0}) == 2
  end
end
