defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with '-h' and '--help' options" do
    assert parse_args(["-h", "dont_care"]) == :help

    assert parse_args(["--help", "dont_care"]) == :help
  end

  test "three values returned if three supplied" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if only two arguments supplied" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
