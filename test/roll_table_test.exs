defmodule RollTableTest do
  use ExUnit.Case
  doctest RollTable

  test "greets the world" do
    table =
      RollTable.new(3, 4)
      |> RollTable.roll({5, 5, 5})
      |> RollTable.roll({4, 4, 4})

    assert table == %{
             0 => %{0 => 4, 1 => 5, 2 => nil, 3 => nil},
             1 => %{0 => 4, 1 => 5, 2 => nil, 3 => nil},
             2 => %{0 => 4, 1 => 5, 2 => nil, 3 => nil},
             _width: 3,
             _length: 4
           }
  end
end
