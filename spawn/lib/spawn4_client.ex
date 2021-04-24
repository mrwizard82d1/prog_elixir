defmodule Spawn4Client do
  def start do
    spawn(Spawn4Client, :init, [])
  end

  def init do
    pid = spawn(Spawn4, :greet, [])
    first pid
    second pid
  end

  def first(pid) do
    send pid, {self, "Client World!"}
    receive do
      {:ok, message} -> IO.puts message
    end
  end

  def second(pid) do
    send pid, {self, "Client Kermit!"}
    receive do
      {:ok, message} -> IO.puts message
    after 500 -> IO.puts "The greeter has gone away"
    end
  end

end
