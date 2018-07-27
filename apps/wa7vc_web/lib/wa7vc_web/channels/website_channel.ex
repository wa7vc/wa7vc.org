defmodule Wa7vcWeb.WebsiteChannel do
  use Phoenix.Channel
  
  def join("website:pingmsg", auth_msg, socket) do
    {:ok, socket}
  end
  def join("website:"<>_private_room_id, _auth_msg, socket) do
    {"error", %{reason: "unauthorized"}}
  end
end
