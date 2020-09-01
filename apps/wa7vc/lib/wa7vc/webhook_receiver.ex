defmodule Wa7vc.WebhookReceiver do
  use GenServer
  alias __MODULE__.Implementation


  @doc """
  Accept the raw body of a github webhook for processing
  """
  def github_hook(hook) do 
    GenServer.cast(__MODULE__, {:receive_github_hook, hook})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    {:ok, opts}
  end


  def handle_cast({:receive_github_hook, hook_body}, state) do
    parsed_hook = Jason.decode!(hook_body)
    Implementation.handle_parsed_github_hook(parsed_hook)
    {:noreply, state}
  end



  defmodule Implementation do
    @moduledoc false

    def handle_parsed_github_hook(_hook) do
      #STM.increment(:github_pushes_count)

      # if push contains commits
      # STM.increment(:github_pushes_with_commits_count)

      #Marvin.IrcRobot.irc_wa7vc_send("Just got a webhook from github, yum!")
      Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "Just got a webhook from github, yum!" }
    end

  end

end

