defmodule Marvin do
  @moduledoc """
  Marvin  is our depressed robot assistant.
  He handles webhooks/irc/notifications, and other boring non-website based
  background tasks.
  """

  def version() do
  {:marvin, _, version} =
    Enum.find(:application.loaded_applications(), fn {app, _, _version} ->
      app == :marvin
    end)

  to_string(version)
  end
end
