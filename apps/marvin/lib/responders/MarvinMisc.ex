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
  end

  hear ~r/notice me senpai/i, msg do
    send msg, "#{msg.user.name} HAS BEEN NOTICED"
    Wa7vcWeb.Endpoint.broadcast! "website:pingmsg", "message", %{ :text => "In #{msg.room} #{msg.user.name} wanted to be noticed, so I obliged." }
  end
end
