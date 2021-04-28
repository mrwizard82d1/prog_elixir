defmodule Parallel do
  import :timer, only: [sleep: 1]

  def pmap(collection, fun) do
    me = self()
    collection
    |> Enum.map(fn (elem) ->
      spawn_link(fn ->
        send me, {self, fun.(elem)}
        # Uncomment the following line, ...
        # sleep 150
      end)
    end)
    |> Enum.map(fn (pid) ->
      receive do
        # uncomment the following line, ...
        # {_pid, result} -> result
        # and comment out the next line
        {^pid, result} -> result
      end
    end)
  end
  # And run the command `Parallel.pmap 1..1000, &(&1 * &1) to **transiently** see failures. (To see them, you
  # need to look closely at the returned values both at the beginning and, more likely, at the end.
  # Specifically, look for **not** ending with 2500.
end
