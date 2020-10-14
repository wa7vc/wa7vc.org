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
    # if not mount matches => return
    # if no signature => error
    # if signature doesn't match => error
    # done.
  end

  def github_api(conn, _options) do
    case conn.method do
      "POST" -> 
        key = Application.get_env(:wa7vc, Wa7vcWeb.Endpoint)[:github_webhook_secret]
        {:ok, body, _} = read_body(conn)
        signature = case get_req_header(conn, "x-hub-signature") do
          ["sha1=" <> signature  | []] -> 
            {:ok, signature} = Base.decode16(signature, case: :lower) 
            signature
          x -> x
        end
        hmac = :crypto.hmac(:sha, key, body)
        case hmac do
          ^signature ->
            Phoenix.PubSub.broadcast(Wa7vc.PubSub, :raw_webhook_received, %{source: "github", body: body})
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, "{ \"code\":200, \"msg\":\"Handled Github Webhook\" }")
            |> halt
          _ ->
            #IO.inspect key, label: "Using Key: "
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(401, "{ \"code\":401, \"msg\":\"You're not github!\" }")
            |> halt
        end
      _ -> 
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(405, "{ \"code\":405, \"msg\":\"Incorrect HTTP method, who even are you?\" }")
        |> halt
    end
  end
end
