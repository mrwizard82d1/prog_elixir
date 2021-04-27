import :timer, only: [sleep: 1]

defmodule SpawnLinkMp4 do
  def start do
    spawn_monitor(SpawnLinkMp4, :start_parent, [])
    receive do
      msg -> IO.puts "Grandparent #{inspect(msg)}"
    end
  end

  def start_parent do
    spawn_link(SpawnLinkMp4, :loop_child, [self()])
    sleep 500
    loop_parent([])
  end

  defp loop_parent(state) do
    receive do
      msg ->
        IO.puts "Received: #{inspect(msg)}"
        loop_parent(state)
    after 1000 ->
      IO.puts "After 1 second, I'm outta' here."
    end
  end

  def loop_child(_parent) do
    raise "kaboom!"
  end
end
