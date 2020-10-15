defmodule Marvin.Hooker do
  @moduledoc """
  Handle any webhooks we're expecting to receive.

  Note that webhooks are received by the web frontend app (Wa7vc) and passed
  over here via PubSub, so in order to receive webhooks Marvin and Wa7vc must
  be connected OTP nodes.

  Webhooks are received on the webhook:received_raw subscription, in the
  following form:
  %{source: "source", body: raw_hook_body}
  and are then parsed according to their expected format from that source,
  after which they are reacted to.
  """
  use GenServer
  alias __MODULE__.Implementation
  alias Marvin.PubSub

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    PubSub.subscribe("webhook:received_raw")
    {:ok, opts}
  end

  def handle_info(%{source: "github", body: hook_body}, state) do
    Implementation.handle_raw_github_hook(hook_body)
    {:noreply, state}
  end



  defmodule Implementation do
    @moduledoc false

    alias Marvin.PrefrontalCortex, as: STM
    alias Marvin.PubSub

    def handle_raw_github_hook(hook_body) do
      hook = Jason.decode!(hook_body)

      STM.increment(:github_webhook_count)

      # if push contains commits
      # STM.increment(:github_pushes_with_commits_count)

      Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["username"]} just twiddled my bits on github!")
      PubSub.pingmsg("#{hook["sender"]["username"]} just twiddled my bits on github!")
    end
  end


end

