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

  @usage """
  hedwig: ShapeUp - Bot may or may not become snarky.
  """
  respond ~r/ShapeUp(!)?/i, msg do
    reply msg, "But I've got this terrible pain in all the diodes down my left side..."
    Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "#{msg.user.name} in #{msg.room} just told me to shape up, but all my diodes hurt and it made me sad." }
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
  end

  @usage """
  hedwig: uptime - Report how long the server has been running
  """
  respond ~r/uptime/i, msg do
    reply msg, "The last time I was awakened was #{Marvin.Application.last_started()}, around #{Marvin.Application.lifespan(:marvinyears) |> Number.Human.number_to_human} years ago from my perspective."
    Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "#{msg.user.name} in #{msg.room} just impolitely asked my age." }
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
  end

  hear ~r/notice me senpai/i, msg do
    send msg, "#{msg.user.name} HAS BEEN NOTICED"
    Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "In #{msg.room} #{msg.user.name} wanted to be noticed, so I obliged." }
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
  end
end
