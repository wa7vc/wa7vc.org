d(efmodule Marvin.HookerTest do
  use ExUnit.Case, async: true
  alias Marvin.Hooker
  alias Marvin.PrefrontalCortex, as: STM

  doctest Marvin.Hooker

  #import Mox
  #setup [:verify_on_exit!]

  @fake_payload "{\"zen\":\"Do or do not, there is no try.\", \"hook_id\":12345, \"hook\":{\"type\":\"Repository\",\"id\":98765,\"name\":\"web\",\"active\":true,\"events\":[\"*\"]}}"
  @fk_delivery "1234567890"

  setup do
    #Marvin.PubSub.subscribe
  end

  # Note that we're implicitly testing the fact that the Marvin.Hooker captures PubSub
  # broadcasts for webhook:received_raw.

  describe "things that happen for all webhooks from github, even if they're not correct", context do
    test "increments the github_webhook_count when a push is received" do
      prev_count = STM.get_counter(:github_webhook_count)
      mock_hook("not-real-event", @fake_payload)
      assert STM.get_counter(:github_webhook_count) == prev_count+1
    end
  end

  describe "handle receiving hook of type push" do
    test "sends pingmsg when a push is received" do
      assert false
    end 
  end

  defp mock_hook(gh_event, gh_body, gh_delivery \\ @fk_delivery) do
    Marvin.PubSub.broadcast(
      "webhook:received_raw",
      %{source: "github",
        delivery: gh_delivery,
        event: gh_event,
        body: gh_body
      })
  end
end
