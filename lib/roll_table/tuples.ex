defmodule RollTable.Tuples do
  @spec new(integer(), integer()) :: map()
  def new(wid, len) do
    tuple = 1..len |> Enum.map(fn _ -> nil end) |> List.to_tuple()

    columns =
      for num <- 1..wid, reduce: %{} do
        table -> Map.put(table, num - 1, tuple)
      end

    %{columns: columns}
    |> Map.put(:idx, 0)
    |> Map.put(:width, wid)
    |> Map.put(:length, len)
  end

  @spec roll(map(), tuple()) :: map()
  def roll(table, new_row) do
    if tuple_size(new_row) != table.width do
      raise "Row length must match table width"
    end

    new_columns =
      for {num, col} <- table.columns, reduce: table.columns do
        columns ->
          Map.put(
            columns,
            num,
            put_elem(col, table.idx, elem(new_row, num))
          )
      end

    table
    |> Map.put(:columns, new_columns)
    |> Map.put(:idx, rem(table.idx + 1, table.length))
  end
end
