defmodule FredWilma do
  def start do
    spawn(FredWilma, :init, [])
  end

  def init do
    IO.puts "Initiator #{inspect(self())}"
    fred = spawn(FredWilma, :worker, [:fred])
    wilma = spawn(FredWilma, :worker, [:wilma])

    send fred, {self(), "fred"}
    send wilma, {self(), "wilma"}

    loop(self())
  end

  def loop(sender) do
    receive do
      {name, token} ->
        IO.puts "#{inspect(self())} received name, #{name}, and token, #{token}."
        loop(sender)
    end
end

def worker(name) do
    IO.puts "Name #{name}, pid #{inspect(self())}}"
    receive do
      {sender, token} ->
        IO.puts "#{inspect(self())}, named #{name}, received token, #{token}, from, #{inspect(sender)}, "
        send sender, {name, token}
    end
  end
end
