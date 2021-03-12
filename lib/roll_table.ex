defmodule RollTable do
  @moduledoc """
  Documentation for `RollTable`.
  """

  @doc """
  RollTable is a 2D table of fixed size that drops the
  last row every time a new row is inserted.

  ## Example
  iex> RollTable.new(3, 4) |> RollTable.roll({5, 5, 5}) |> RollTable.roll({4, 4, 4})
  %{
    0 => %{0 => 4, 1 => 5, 2 => nil, 3 => nil},
    1 => %{0 => 4, 1 => 5, 2 => nil, 3 => nil},
    2 => %{0 => 4, 1 => 5, 2 => nil, 3 => nil},
    _length: 4,
    _width: 3
  }
  """

  @spec new(integer(), integer()) :: map()
  def new(wid, len) do
    Enum.reduce(0..(wid - 1), %{}, fn col, table ->
      put_in(
        table[col],
        Enum.map(0..(len - 1), fn row -> {row, nil} end) |> Map.new()
      )
    end)
    |> put_in([:_width], wid)
    |> put_in([:_length], len)
  end

  @spec roll(map(), tuple()) :: map()
  def roll(table, new_row) do
    Enum.reduce(0..(table._width - 1), table, fn col, table ->
      Enum.reduce(0..(table._length - 1), table, fn row, t2 ->
        case row do
          0 -> put_in(t2[col][row], elem(new_row, col))
          _ -> put_in(t2[col][row], table[col][row - 1])
        end
      end)
    end)
  end
end
