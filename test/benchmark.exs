range = 1..1000

table_t = RollTable.Tuples.new(5, 100)
table_m = RollTable.Maps.new(5, 100)

{:ok, tuples_agent} = Agent.start(fn -> table_t end)
{:ok, maps_agent} = Agent.start(fn -> table_m end)

Benchee.run(%{
  "RollTable.Tuples" => fn ->
    for n <- range do
      Agent.update(tuples_agent, fn table ->
        RollTable.Tuples.roll(table, {n + 1, n + 2, n + 3, n + 4, n + 5})
      end)
    end
  end,
  "RollTable.Maps" => fn ->
    for n <- range do
      Agent.update(maps_agent, fn table ->
        RollTable.Maps.roll(table, {n + 1, n + 2, n + 3, n + 4, n + 5})
      end)
    end
  end
})
