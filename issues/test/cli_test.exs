defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [convert_to_list_of_maps: 1, parse_args: 1, sort_into_ascending_order: 1]

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

  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issues <- result, do: issues["created_at"]
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values, do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_list_of_maps data
  end
end
