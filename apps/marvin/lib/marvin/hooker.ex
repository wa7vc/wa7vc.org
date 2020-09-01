defmodule Marvin.Hooker do
  use GenServer
  alias Marvin.PrefrontalCortex, as: STM

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    {:ok, opts}
  end




  def handle_cast({:receive_github_hook, parsed_hook}, state) do
    handle_received_github_hook(parsed_hook)
    {:noreply, state}
  end
  def receive_github_hook(hook) do 
    GenServer.cast(__MODULE__, {:receive_github_hook, hook})
  end

  def handle_received_github_hook(_hook) do
    STM.increment(:github_pushes_count)

    # if push contains commits
    # STM.increment(:github_pushes_with_commits_count)

    Marvin.IrcRobot.irc_wa7vc_send("Just got a webhook from github, yum!")
    Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "Just got a webhook from github, yum!" }
  end


end

