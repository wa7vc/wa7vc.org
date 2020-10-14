# Used modified from https://github.com/hamiltop/ashes/blob/master/lib/ashes/github_webhook_plug.ex
defmodule Wa7vcWeb.Plugs.GithubWebhookReceiver do
  import Plug.Conn
  
  def init(options) do
    options
  end

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
        key = Application.get_env(:wa7vc, Wa7vcWeb.Endpoint)[:github_webhook_secret]
        {:ok, body, _} = read_body(conn)
        signature = case get_req_header(conn, "x-hub-signature") do
          # Note that this will error out if the string following sha1= doesn't correctly base16 decode.
          # Since that implies that this isn't a valid github webhook, we're okay with that.
          ["sha1=" <> signature  | []] ->
            case Base.decode16(signature, case: :lower) do
              {:ok, sig} -> sig
              _ -> :error
            end
          _ -> :error
        end
        decoded_sig = :crypto.hmac(:sha, key, body)
        case decoded_sig do
          ^signature ->
            Phoenix.PubSub.broadcast(Wa7vc.PubSub, "webhook:received_raw", %{source: "github", body: body})
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, "{ \"code\":200, \"msg\":\"Ingested Webhook, thanks Github!\" }")
            |> halt
          _ ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(401, "{ \"code\":401, \"msg\":\"Invalid Signature. You're not Github!\" }")
            |> halt
        end
      _ -> 
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(405, "{ \"code\":405, \"msg\":\"Incorrect HTTP Method, who even are you?\" }")
        |> halt
    end
  end
end
