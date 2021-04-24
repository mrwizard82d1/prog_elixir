#!/bin/bash
for n in 1000 10000 100000 1000000
do
	elixir --erl "+P 1000000" -r lib/chain.ex -e "Chain.run(${n})"
done
