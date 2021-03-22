defmodule RollTable.Maps do
  @moduledoc """
  Documentation for `RollTable.Maps`.
  """

  @doc """
  RollTable is a list of circular queues.

  ## Example
  iex> RollTable.Maps.new(3, 4) |> RollTable.Maps.roll({5, 5, 5}) |> RollTable.Maps.roll({4, 4, 4})
  %{
    columns: %{
      0 => %{0 => 5, 1 => 4, 2 => nil, 3 => nil},
      1 => %{0 => 5, 1 => 4, 2 => nil, 3 => nil},
      2 => %{0 => 5, 1 => 4, 2 => nil, 3 => nil}
    },
    length: 4,
    width: 3,
    idx: 2
  }
  """

  @spec new(integer(), integer()) :: map()
  def new(wid, len) do
    column =
      1..len
      |> Enum.map(fn num -> {num - 1, nil} end)
      |> Map.new()

    columns =
      1..wid
      |> Enum.map(fn col -> {col - 1, column} end)
      |> Map.new()

    %{columns: columns}
    |> put_in([:idx], 0)
    |> put_in([:width], wid)
    |> put_in([:length], len)
  end

  @spec roll(map(), tuple()) :: map()
  def roll(table, new_row) do
    if tuple_size(new_row) != table.width do
      raise "Row length must match table width"
    end

    table =
      for col <- 0..(table.width - 1), reduce: table do
        t -> put_in(t.columns[col][table.idx], elem(new_row, col))
      end

    put_in(table.idx, rem(table.idx + 1, table.length))
  end
end
