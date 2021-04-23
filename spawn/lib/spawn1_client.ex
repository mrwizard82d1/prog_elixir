defmodule Spawn1Client do
  def start do
    spawn(Spawn1Client, :init, [])
  end

  def init do
    pid = spawn(Spawn1, :greet, [])
    send pid, {self, "Client World!"}
    loop
  end

  def loop do
    receive  do
      {:ok, message} -> IO.puts message
    end
  end
end
