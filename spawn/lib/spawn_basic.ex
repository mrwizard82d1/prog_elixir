defmodule SpawnBasic do
  # This module simply defines a function. The client will spawn a process that runs this function.
  def greet do
    IO.puts "Hello"
  end
end
