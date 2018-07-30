defmodule Wa7vcWeb.WebhookController do
  use Wa7vcWeb, :controller

  # plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end

  def github_webhook(conn, params) do
    event_type = get_req_header(conn, "x-github-event") |> List.first()
    signature = get_req_header(conn, "x-hub-signature") |> List.first()

    body = read_body(conn)

    case Marvin.GithubWebhookHandler.handle_hook(signature, body) do
      {:ok} ->
        Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "Got a #{event_type} event from GitHub!" }
        render conn, "github_webhook_response.json", %{event_type: event_type}
      _ -> render conn, "github_webhook_error.json", %{}
    end

  end
end
