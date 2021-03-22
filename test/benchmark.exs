range = 1..1000

table_t = RollTable.Tuples.new(3, 2)
table_m = RollTable.Maps.new(3, 2)

table_b = %{
  0 => %{0 => nil, 1 => nil},
  1 => %{0 => nil, 1 => nil},
  2 => %{0 => nil, 1 => nil},
  length: 2,
  width: 3
}

Benchee.run(%{
  "Manual update" => fn ->
    for _ <- range do
      put_in(table_b[0][1], table_b[0][0])
      put_in(table_b[1][1], table_b[1][0])
      put_in(table_b[2][1], table_b[2][0])
      put_in(table_b[0][0], 5)
      put_in(table_b[1][0], 5)
      put_in(table_b[2][0], 5)
    end
  end,
  "RollTable.Tuples" => fn ->
    for _ <- range do
      RollTable.Tuples.roll(table_t, {1, 1, 1})
    end
  end,
  "RollTable.Maps" => fn ->
    for _ <- range do
      RollTable.Maps.roll(table_m, {1, 1, 1})
    end
  end
})
