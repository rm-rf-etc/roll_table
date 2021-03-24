defmodule RollTable.Tuples do
  alias __MODULE__, as: RTT

  @type table :: %__MODULE__{}

  defstruct private_columns: %{},
            public_columns: %{},
            length: nil,
            width: nil,
            idx: 0

  @behaviour Access

  defmacro __using__(_opts) do
    quote do
      @behaviour Access

      @impl Access
      def fetch(struct, key) do
        RTT.fetch(struct, key)
      end

      @impl Access
      def get_and_update(_, _, _) do
        RTT.get_and_update(nil, nil, nil)
      end

      @impl Access
      def pop(_, _, _ \\ nil) do
        RTT.pop(nil, nil)
      end

      defoverridable Access
    end
  end

  def fetch(table, {col, row}) when is_integer(col) and is_integer(row) do
    cond do
      col < 0 -> raise "cannot reference columns less than 0"
      row < 0 -> raise "cannot reference rows less than 0"
      col >= table.width -> raise "cannot reference columns beyond width: #{table.width}"
      row >= table.length -> raise "cannot reference rows beyond length: #{table.length}"
      true -> {:ok, table.private_columns[col] |> elem(rem(row, table.length))}
    end
  end

  def get_and_update(_, _, _) do
    {nil, nil}
  end

  def pop(_, _) do
    {nil, nil}
  end

  @spec new(integer(), integer()) :: map()
  def new(wid, len) do
    tuple = 1..len |> Enum.map(fn _ -> nil end) |> List.to_tuple()

    columns =
      for num <- 1..wid, reduce: %{} do
        table -> Map.put(table, num - 1, tuple)
      end

    %RTT{private_columns: columns}
    |> Map.put(:idx, 0)
    |> Map.put(:width, wid)
    |> Map.put(:length, len)
  end

  @spec roll(map(), tuple()) :: map()
  def roll(table, new_row) when tuple_size(new_row) == table.width do
    new_columns =
      for {num, col} <- table.private_columns, reduce: table.private_columns do
        columns ->
          Map.put(
            columns,
            num,
            put_elem(col, table.idx, elem(new_row, num))
          )
      end

    table
    |> Map.put(:private_columns, new_columns)
    |> Map.put(:idx, rem(table.idx + 1, table.length))
  end
end
