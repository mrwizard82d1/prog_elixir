defmodule Chain do
  def counter(next_pid) do
    receive do
      n -> send next_pid, n + 1
    end
  end

  def create_processes(n) do
    last = Enum.reduce 1..n, self(), fn (_, send_to) -> spawn(Chain, :counter, [send_to]) end

    # Start the count by sending 0 to the last process created. (Remember that the processes are "linked"
    # from last to first, and ...
    send last, 0

    # ...and wait for the result to come back to us.
    receive do
      # The guard clauses addresses a bug in some Elixir implementations that leave a compilation message in
      # the queue of the (last) process. The guard clause ignores that message.
      final_answer when is_integer(final_answer) -> "Result is #{inspect(final_answer)}"
    end
  end

  def run(n) do
    IO.puts inspect(:timer.tc(Chain, :create_processes, [n]))
  end
end
