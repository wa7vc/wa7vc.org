# Used modified from https://github.com/hamiltop/ashes/blob/master/lib/ashes/github_webhook_plug.ex

defmodule Marvin.GithubWebhookPlug do
  import Plug.Conn
  require Logger
  
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

  def github_api(conn, options) do
    key = options[:secret]
    {:ok, body, _} = read_body(conn)
    signature = case get_req_header(conn, "x-hub-signature") do
      ["sha1=" <> signature  | []] -> 
        {:ok, signature} = Base.decode16(signature, case: :lower) 
        signature
      x -> x
    end
    hmac = :crypto.hmac(:sha, key, body)
    Logger.info("Handling Github Webhook. Using key: #{key}, expecting #{Base.encode16(signature, case: :lower)}, calculated #{Base.encode16(hmac, case: :lower)}")
    case hmac do
      ^signature ->
        hook = Poison.decode!(body)
        Marvin.Hooker.receive_github_hook(hook)
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "{ \"code\":200, \"msg\":\"Handled Github Webhook\" }")
        |> halt
      _ ->
        IO.inspect key, label: "Using Key: "
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, "{ \"code\":401, \"msg\":\"You're not github!\", \"calculated\":\"#{Base.encode16(hmac, case: :lower)}\", \"given\":\"#{Base.encode16(signature, case: :lower)}\" }")
        |> halt
    end
  end
end
