defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir mrwizard82d1@gmail.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    # |> HTTPoison.get()
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, :jsx.decode(body)}
  end
  def handle_response({:error, reason}) do
    {:error, :jsx.decode(reason)}
  end
end
