defmodule Hedwig.Responders.MarvinMisc do
  @moduledoc """
  Marvin does some strange things, not all of them obvious or documented.
  He is very depressed, after all.

  Responders can get the following information about messages:
  \#{msg.user.name}
  \#{msg.room}
  \#{msg.user.text}
  """

  use Hedwig.Responder
  alias Hedwig.Message
  alias Marvin.PubSub

  @usage """
  hedwig: ShapeUp - Bot may or may not become snarky.
  """
  respond ~r/ShapeUp(!)?/i, msg do
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
    PubSub.pingmsg("#{msg.user.name} in #{msg.room} just told me to shape up, but all my diodes hurt and it made me sad.")
    reply msg, "But I've got this terrible pain in all the diodes down my left side..."
  end

  hear ~r/notice me senpai/i, msg do
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
    PubSub.pingmsg("In #{msg.room} #{msg.user.name} wanted to be noticed, so I obliged.")
    send msg, "#{msg.user.name} HAS BEEN NOTICED"
  end

  hear ~r/borked/i, msg do
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
    PubSub.pingmsg("bork bork bork...")
    send msg, "bork bork bork..."
  end


end
