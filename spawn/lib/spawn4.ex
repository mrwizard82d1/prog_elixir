defmodule Spawn4 do
  def greet do
    receive do
      {sender, msg} -> send sender, {:ok, "Hello, #{msg}"}
      greet # recurse after processing each message
    end
  end
end
