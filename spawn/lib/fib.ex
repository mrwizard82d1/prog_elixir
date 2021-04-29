defmodule FibSolver do
  def fib(scheduler) do
    send scheduler, {:ready, self()}
    receive do
      {:fib, n, client} ->
        send client, {:answer, n, fib_calc(n), self()}
        fib(scheduler) # Recurse
      {:shutdown} -> exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n) when is_integer(n) and n >= 0, do: fib_calc(n - 1) + fib_calc(n - 2)
end

defmodule Scheduler do
  def run(process_count, module, func, to_calculate) do
    (1..process_count)
    |> Enum.map(fn (_) -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when (queue != []) ->
        [next | tail] = queue
        send pid, {:fib, next, self()}
        # Recurse while more work to do (queue not empty)
        schedule_processes(processes, tail, results)
      {:ready, pid} ->
        # No work to do so clean up
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          # if no processes remaining, sort the results by Fibonacci number requested
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end
      {:answer, number, result, _pid} -> schedule_processes(processes, queue, [{number, result} | results])
    end
  end
end
