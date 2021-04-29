to_process = [37, 37, 37, 37, 37, 37]
calculate_fibonacci_numbers = fn process_count ->
  {time, result} = :timer.tc(Scheduler, :run, [process_count, FibSolver, :fib, to_process])
  if process_count == 1 do
    IO.puts inspect result
    IO.puts "\n #   time (s)"
  end
  :io.format "~2B      ~.2f~n", [process_count, time / 1000000.0]
end

Enum.each 1..10, calculate_fibonacci_numbers
