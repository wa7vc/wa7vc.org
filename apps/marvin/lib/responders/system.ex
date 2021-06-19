defmodule Marvin.Responders.System do
  @moduledoc """
  Marvin likes to talk about himself
  """

  use Hedwig.Responder
  alias Hedwig.Message
  alias Marvin.PubSub


  @usage """
  hedwig: uptime - Report how long the server has been running
  """
  respond ~r/uptime$/i, msg do
    Marvin.PrefrontalCortex.increment(:irc_interactions_count)
    PubSub.pingmsg("#{msg.user.name} in #{msg.room} just impolitely asked my age.")
    reply msg, "The last time I was awakened was #{Marvin.Application.last_started()}, around #{Marvin.Application.lifespan(:marvinyears) |> Number.Human.number_to_human} years ago from my perspective."
  end

end
