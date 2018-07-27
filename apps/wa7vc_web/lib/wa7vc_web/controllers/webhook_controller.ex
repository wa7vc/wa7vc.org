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

    # Calculate HMAC SHA-1 hash of body using Wa7vc.Endpoint.github_webhook_secret as the salt
    # If hash matches signature, hand off handling of this hook and return a good response.
    #case valid_hash(body,hash) do
      #{:ok, hash} ->
        Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "Got a #{event_type} event from GitHub!" }
        render conn, "github_webhook_response.json", %{event_type: event_type}
      #{:error, :invalid_header} ->
        #render TODO: ERROR

  end
end
