defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir mrwizard82d1@gmail.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  # Use a module attribute to fetch the value at compile time
  @github_url Application.get_env(:issues, :github_url)
  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, :jsx.decode(body)}
  end
  def handle_response({:error, reason}), do: {:error, reason}
end
