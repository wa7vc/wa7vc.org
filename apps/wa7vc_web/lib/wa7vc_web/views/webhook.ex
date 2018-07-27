defmodule Wa7vcWeb.WebhookView do
  use Wa7vcWeb, :view

  def render("github_webhook_response.json", %{event_type: event_type}) do
    %{
      code: 200,
      msg: "Accepted event of type \"#{event_type}\"",
    }
  end
end
