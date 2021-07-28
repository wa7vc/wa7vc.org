defmodule Wa7vcWeb.Plugs.GithubWebhookReceiver do
  @moduledoc """
  Receive any webhooks sent by Github.

  This plug is mounted at the path defined in endpoint.ex, and required that
  the endpoint config contain a "github_webhook_secret" key, which is the
  shared secret that is entered into Github's webhook configuration.

  Returns JSON payloads containg an "code" field matching the HTTP status code
  being returned, and an "msg" field containing a textual description of the
  result.
  Not that Github cares, long as we return a 200... But it's fun.

  Used concept modified from
  https://github.com/hamiltop/ashes/blob/master/lib/ashes/github_webhook_plug.ex
  """
  import Plug.Conn
  
  def init(options) do
    options
  end

  # Parse the webhook if the request is for where we're mounted, otherwise
  # take no action and pass the conn on down the line
  def call(conn, options) do
    mount = options[:mount]
    case conn.request_path do
      ^mount -> github_api(conn, options)
      _ -> conn
    end
  end

  defp github_api(conn, _options) do
    case conn.method do
      "POST" -> 
        key = Application.get_env(:wa7vc, 
                                  Wa7vcWeb.Endpoint)[:github_webhook_secret]
        {:ok, body, conn} = read_body(conn)

        calculated_signature = :crypto.mac(:hmac, :sha, key, body)

        case extract_github_signature(conn)
             |> decode_base16_signature
             |> signature_matches(calculated_signature) do
          true ->
            gh_action = get_resp_header(conn, "X-GitHub-Event") |> List.first(:unknown)
            gh_delivery = get_resp_header(conn, "X-GitHub-Delivery") |> List.first(:unknown)
            Phoenix.PubSub.broadcast(Wa7vc.PubSub,
                                     "webhook:received_raw",
                                     %{source: "github", delivery: gh_delivery, action: gh_action, body: body})
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, "{ \"code\":200, "
               <> "\"msg\":\"Ingested Webhook, thanks Github!\" }")
            |> halt
          false ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(401, "{ \"code\":401, "
               <> "\"msg\":\"Invalid Signature. You're not Github!\" }")
            |> halt
        end
      _ -> 
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(405, "{ \"code\":405, "
           <> "\"msg\":\"Incorrect HTTP Method, who even are you?\" }")
        |> halt
    end
  end


  #####
  # Method chain for cleanly extracting and validating the signature attached
  # to the webhook sent by github.
  #####

  defp extract_github_signature(conn) do
    case get_req_header(conn, "x-hub-signature") do
      ["sha1=" <> signature | []] -> signature
      _ -> :error
    end
  end

  defp decode_base16_signature(sig) do
    case Base.decode16(sig, case: :lower) do
      {:ok, decoded_sig} -> decoded_sig
      _ -> :error
    end
  end

  defp signature_matches(request_signature, calculated_signature) do
    request_signature == calculated_signature
  end

end
