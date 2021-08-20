defmodule Wa7vcWeb.Plugs.GithubWebhookPlugTest do
  use Wa7vcWeb.ConnCase, async: true

  # Use an arbitrary secret for these tests that is unrelated to our production
  # secret. Ideally we would generate a random secret for each test run,
  # allowing us to be totally certain that the module was implementing the
  # hash checking correctly, but for now, meh.
  @secret Application.get_env(:wa7vc, Wa7vcWeb.Endpoint)[:github_webhook_secret]
  # Use an arbitrary JSON blob as a payload. Any testing of how the *contents*
  # are handled is done in the Marvin.Hooker testing
  @payload "{\"zen\":\"Do or do not, there is no try.\", \"hook_id\":12345, \"hook\":{\"type\":\"Repository\",\"id\":98765,\"name\":\"web\",\"active\":true,\"events\":[\"*\"]}}"


  test "get request returns 405 method not allowed", %{conn: conn} do
    conn = get(conn, "/webhooks/github")
    assert conn.status == 405
    assert %{"code" => 405, "msg" => message} = json_response(conn, 405)
    assert message =~ "Incorrect HTTP Method"
  end

  test "put request returns 405 method not allowed", %{conn: conn} do
    conn = put(conn, "/webhooks/github")
    assert conn.status == 405
    assert %{"code" => 405, "msg" => message} = json_response(conn, 405)
    assert message =~ "Incorrect HTTP Method"
  end

  test "delete request returns 405 method not allowed", %{conn: conn} do
    conn = delete(conn, "/webhooks/github")
    assert conn.status == 405
    assert %{"code" => 405, "msg" => message} = json_response(conn, 405)
    assert message =~ "Incorrect HTTP Method"
  end

  test "request with invalid signature  is rejected with a 401", %{conn: conn} do
    conn = conn
           |> put_req_header("content-type", "application/json")
           |> put_req_header("x-hub-signature", "sha1=InvalidASha1")
           |> post("/webhooks/github", @payload)
    assert conn.status == 401
    assert %{"code" => 401, "msg" => message} = json_response(conn, 401)
    assert message =~ "Invalid Signature"
  end

  test "webhook with incorrect hash is rejected with a 401", %{conn: conn} do
    conn = conn
           |> put_req_header("content-type", "application/json")
           |> put_req_header("x-hub-signature", "sha1=" <> bad_signature_for(@payload))
           #|> put_req_header("x-hub-signature", "sha1=InvalidASha1")
           |> post("/webhooks/github", @payload)
    assert conn.status == 401
    assert %{"code" => 401, "msg" => message} = json_response(conn, 401)
    assert message =~ "Invalid Signature"
  end

  test "authenticated webhook returns a 200 and sends body as pubsub message", %{conn: conn} do
    Phoenix.PubSub.subscribe(Wa7vc.PubSub, "webhook:received_raw")
    expected_broadcast = %{source: "github", body: @payload, event: "push", delivery: "delivery-UUID"}

    conn = conn
           |> put_req_header("content-type", "application/json")
           |> put_req_header("x-hub-signature", "sha1=" <> signature_for(@payload))
           |> put_req_header("x-github-event", "push")
           |> put_req_header("x-github-delivery", "delivery-UUID")
           |> post("/webhooks/github", @payload)

    assert conn.status == 200
    assert %{"code" => 200, "msg" => message} = json_response(conn, 200)
    assert message =~ "Ingested Webhook"
    assert_receive ^expected_broadcast
  end


  # Github uses SHA1 to calculate the hash using the shared secret.
  defp signature_for(body) do
    :crypto.mac(:hmac, :sha, @secret, body)
    |> Base.encode16(case: :lower)
  end

  # Generate a signature using the wrong secret.
  defp bad_signature_for(body) do
    :crypto.mac(:hmac, :sha, "gQXRRtDkqrrPXr3aGzzv0rNRf3he5HKOO9u5AOAmT+Uhf0VVOUc4xRAKB3/AE+iT", body)
    |> Base.encode16(case: :lower)
  end
end
