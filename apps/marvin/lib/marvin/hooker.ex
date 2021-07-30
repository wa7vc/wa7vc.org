defmodule Marvin.Hooker do
  @moduledoc """
  Handle any webhooks we're expecting to receive.

  Note that webhooks are received by the web frontend app (Wa7vc) and passed
  over here via PubSub, so in order to receive webhooks Marvin and Wa7vc must
  be connected OTP nodes.

  Webhooks are received on the webhook:received_raw subscription, in the
  following form:
  %{source: "source", delivery: x_github_delivery_header_value, action: x_github_action_header_value, body: raw_hook_body}
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

  def handle_info(%{source: "github", delivery: hook_guid, action: hook_action, body: hook_body}, state) do
    Implementation.handle_raw_github_hook(hook_guid, hook_action, hook_body)
    {:noreply, state}
  end



  defmodule Implementation do
    @moduledoc false

    alias Marvin.PrefrontalCortex, as: STM
    alias Marvin.PubSub

    def handle_raw_github_hook(_hook_guid, hook_action, hook_body) do
      hook = Jason.decode!(hook_body)

      STM.increment(:github_webhook_count)

      case hook_action do
        "push" -> 
          if Map.has_key?(hook, "commits") do
            commit_count = Enum.count(hook["commits"])
            STM.increment(:github_pushes_with_commits_count)
            STM.increment(:github_commits_count, commit_count)

            Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} just twiddled my bits on github! #{commit_count} commits on #{hook["ref"]} were pushed.")
            PubSub.pingmsg("#{hook["sender"]["login"]} just twiddled my bits on github! #{commit_count} times!")
          end
        "delete" ->
          Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} just reprogrammed me with a very large axe! #{hook["ref-type"]} #{hook["ref"]} deleted!")
          PubSub.pingmsg("#{hook["sender"]["login"]} just reprogrammed me with a very large axe!")
        "create" -> Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} pushed #{hook["ref_type"]} #{hook["ref"]}.")
        "repository_vulnerability_alert" -> Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} says we may have a vulnerabiity in #{hook["alert"]["affected_package_name"]}. No wonder my diodes hurt.")
        "pull_request" -> Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} #{hook["action"]} a pull request. (#{hook["pull_request"]["html_url"]})")
        "issues" -> Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} #{hook["action"]} issue: #{hook["issue"]["title"]} (#{hook["issue"]["html_url"]})")
        "issue_comment" -> Marvin.IrcRobot.irc_wa7vc_send("#{hook["sender"]["login"]} #{hook["action"]} comment on issue: #{hook["issue"]["title"]} (#{hook["issue"]["html_url"]})")
        :no_event -> Marvin.IrcRobot.irc_wa7vc_send("GitHub just said something that I couldn't understand... That's a bit worrying.")
        _ -> 
          Marvin.IrcRobot.irc_wa7vc_send("GitHub just sent me a webhook with action #{hook_action}, but I'm ignoring it...")
          PubSub.pingmsg("GitHub just sent me a webhook, but I'm ignoring it...")
      end
    end
  end

end

