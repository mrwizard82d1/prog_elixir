defmodule Spawn2Client do
  def start do
    spawn(Spawn2Client, :init, [])
  end

  def init do
    pid = spawn(Spawn2, :greet, [])
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
    end
  end

end
