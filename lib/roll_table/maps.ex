defmodule RollTable.Maps do
  alias __MODULE__, as: RT

  # @behaviour Access
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

  defstruct private_columns: %{},
            public_columns: %{},
            length: nil,
            width: nil,
            idx: 0

  @type table :: %__MODULE__{}

  @spec new(integer(), integer()) :: table()
  def new(wid, len) do
    column =
      1..len
      |> Enum.map(fn num -> {num - 1, nil} end)
      |> Map.new()

    columns =
      1..wid
      |> Enum.map(fn col -> {col - 1, column} end)
      |> Map.new()

    %RT{private_columns: columns}
    |> put_in([:idx], 0)
    |> put_in([:width], wid)
    |> put_in([:length], len)
  end

  @spec roll(table(), tuple()) :: map()
  def roll(table, new_row) when tuple_size(new_row) == table.width do
    table =
      for col <- 0..(table.width - 1), reduce: table do
        t -> put_in(t.private_columns[col][table.idx], elem(new_row, col))
      end

    put_in(table.idx, rem(table.idx + 1, table.length))
  end

  # @spec fetch(table(), {integer(), integer()}) :: {:ok, any()}
  # def fetch(table, {col, row}) do
  #   {:ok, table[col] |> elem(row)}
  # end

  # @spec get_and_update(table(), any(), any()) :: {nil, nil}
  # def get_and_update(_, _, _) do
  #   {nil, nil}
  # end

  # @spec pop(table(), any()) :: {nil, nil}
  # def pop(_, _) do
  #   {nil, nil}
  # end
end
