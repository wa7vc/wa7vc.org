defmodule Wa7vcWeb.HelperComponents do
  use Phoenix.Component
  #alias Phoenix.LiveView.JS
  #import Wa7vcWeb.Gettext
  import Phoenix.HTML.Tag

  def meta(assigns) do
    if assigns[:meta_attrs] == nil do
      ~H""
    else
      ~H"""
      <%= for tag <- assigns[:meta_attrs] do %>
        <%= content_tag(:meta, Enum.into(tag, [])) %>
      <% end %>
      """
    end
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
