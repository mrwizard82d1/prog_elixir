defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir mrwizard82d1@gmail.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body}
  def handle_response({:error, reason}), do: {:error, reason}
end
