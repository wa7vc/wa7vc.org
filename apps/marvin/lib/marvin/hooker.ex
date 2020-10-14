defmodule Marvin.Hooker do
  use GenServer
  alias __MODULE__.Implementation
  alias Marvin.PubSub

  @doc """
  Feed a parsed json webhook into the genserver to be handled
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    PubSub.subscribe("webhook:received")
    {:ok, opts}
  end

  def handle_info({:raw_webhook_received, %{source: "github", body: hook_body}}, state) do
    IO.puts("hooker got raw github hook")
    Implementation.handle_raw_github_hook(hook_body)
    {:noreply, state}
  end



  defmodule Implementation do
    @moduledoc false

    alias Marvin.PrefrontalCortex, as: STM
    alias Marvin.PubSub

    def handle_raw_github_hook(hook_body) do
      IO.puts("Implementation, handling github hook")
      hook = Jason.decode!(hook_body)

      STM.increment(:github_pushes_count)

      # if push contains commits
      # STM.increment(:github_pushes_with_commits_count)

      Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["username"]} just twiddled my bits on github!")
      PubSub.pingmsg("#{hook["sender"]["username"]} just twiddled my bits on github!")
    end
  end


end

