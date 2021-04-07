defmodule Issues.CLI do
  # The number of issue returned from GitHub if the user does not specify a count herself
  @default_count 4

  @moduledoc """
  Handle the command line argument parsing and the dispatch to the various functions that generate a table of
  the last _n_ issues in a GitHub project.
  """

  def run(argv) do
    argv
      |> parse_args
      |> dispatch
  end

  @doc """
  `argv` can be "-h" or "--help" which returns :help. Otherwise, this function expects the user to specify
  the GitHub user name, project name, and, optionally, the number of entries to format.

  Returns a tuple of `{ user, project, count }` or `:help` if the user requested help.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, strict: [help: :boolean], aliases: [h: :help])
    case parse do
      {[help: true], _, _} ->
        # User specifically asks for help
        :help
      {_, [user, project, count], _} ->
        # User supplies all arguments (including `count`)
        {user, project, String.to_integer(count)}
      {_, [user, project], _} ->
        # Supply no count on command line => use default count
        {user, project, @default_count}
      _
        # Any other parse result
        -> :help
    end
  end

  def dispatch(:help) do
    IO.puts """
      usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def dispatch({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    # The function, `decode_response`, returns a list of maps already (latest version?)
    # |> convert_to_list_of_maps
    |> sort_into_ascending_order
    |> Enum.take(count)
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, reason}) do
    {_, message} = List.keyfind(reason, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_list_of_maps(list) do
     Enum.map(list, &Enum.into(&1, Map.new))
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, fn left, right -> left["created_at"] <= right["created_at"] end
  end

end
