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

  
  slot :h1
  slot :h2
  attr :image, :string, default: "/images/overhead-640x480.png"
  attr :image_alt, :string, default: "A drone shot looking down on an event at Valley Camp"
  def hero(assigns) do
    ~H"""
      <div id="hero">
        <h1><%= render_slot(@h1) || "WA7VC" %></h1>
        <h2><%= render_slot(@h2) || "Ham Radio in the Snoqualmie Middle Fork Valley" %></h2>
        <img src={ @image } alt={ @image_alt } />
        <img src="/images/wave-top-white.svg" alt="A background image of a sine wave" class="translate-y-1"/>
      </div>
    """
  end
end
