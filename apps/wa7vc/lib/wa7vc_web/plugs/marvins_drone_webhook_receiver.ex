defmodule Wa7vcWeb.Plugs.MarvinsDroneWebhookReceiver do
  @moduledoc """
  Receives webhooks posted by one of our custom "Marvin's Drone" applications.

  """

  import Plug.Conn

  def init(options) do
    options
  end

  # Handle requests for the path we're mounted at,
  # otherwise take no action and pass on the conn to be handled
  def call(conn, options) do
    mount = options[:mount]
    case conn.request_path do
      ^mount -> drone_api(conn, options)
      _ -> conn
    end
  end

  defp drone_api(conn, _options) do
    case conn.method do
      "POST" -> 
        {:ok, body, conn} = read_body(conn)

        hook_event = get_req_header(conn, "x-hook-event") |> List.first(:no_event)
        delivery_uuid = get_req_header(conn, "x-hook-delivery") |> List.first(:no_uuid)
        Phoenix.PubSub.broadcast(Wa7vc.PubSub,
                                 "webhook:received_raw",
                                 %{source: "marvins_drone", delivery: delivery_uuid, event: hook_event, body: body})
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, "{ \"code\":200, \"msg\":\"Ingested Drone Webhook\" }")
        |> halt
      _ -> 
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(405, "{ \"code\":405, "
           <> "\"msg\":\"Incorrect HTTP Method, who even are you?\" }")
        |> halt
    end

  end
end
