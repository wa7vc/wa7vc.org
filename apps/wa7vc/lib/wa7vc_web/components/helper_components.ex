defmodule Wa7vcWeb.HelperComponents do
  use Phoenix.Component
  #alias Phoenix.LiveView.JS
  #import Wa7vcWeb.Gettext
  import Phoenix.HTML.Tag

  attr :attrs, :list, default: []
  def meta_tags_for(assigns) do
    ~H"""
    <%= for tag <- @attrs do %>
      <%= tag(:meta, Enum.into(tag, [])) %>
    <% end %>
    """
  end

  def hero(assigns) do
    ~H"""
    <div id="hero">
      <h1>WA7VC</h1>
      <h2>Ham Radio in the Snoqualmie Middle Fork Valley</h2>
    </div>

    <div id="hero-image" class="upper-curve">
      <img src="/images/overhead-640x480.png" alt="Looking down on an event." />
    </div>
    """
  end
end
