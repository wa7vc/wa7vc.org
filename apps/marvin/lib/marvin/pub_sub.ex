defmodule Marvin.PubSub do
  @moduledoc """
  Shortcut to work with Phoenix.PubSub 
  """

  def broadcast(topic, event, payload) do
    Phoenix.PubSub.broadcast!(Wa7vc.PubSub, topic, %{
      __struct__: Phoenix.Socket.Broadcast,
      topic: topic,
      event: event,
      payload: payload
    })
  end

  def subscribe(topic), do: Phoenix.PubSub.subscribe(Wa7vc.PubSub, topic)

  def unsubscribe(topic), do: Phoenix.PubSub.unsubscribe(Wa7vc.PubSub, topic)
end
