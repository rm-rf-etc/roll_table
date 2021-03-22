defmodule RollTableTest do
  use ExUnit.Case
  doctest RollTable.Maps

  test "greets the world" do
    table =
      RollTable.Maps.new(3, 4)
      |> RollTable.Maps.roll({5, 5, 5})
      |> RollTable.Maps.roll({4, 4, 4})

    assert table == %{
             columns: %{
               0 => %{0 => 5, 1 => 4, 2 => nil, 3 => nil},
               1 => %{0 => 5, 1 => 4, 2 => nil, 3 => nil},
               2 => %{0 => 5, 1 => 4, 2 => nil, 3 => nil}
             },
             length: 4,
             width: 3,
             idx: 2
           }
  end
end
