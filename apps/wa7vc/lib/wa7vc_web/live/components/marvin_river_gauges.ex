defmodule Wa7vcWeb.MarvinRiverGaugesComponent do
  use Wa7vcWeb, :live_component
  import Phoenix.HTML.Link

  def render(assigns) do
    ~L"""
    <%= if @stations do %>
      <%= for station <- @stations do %>
          <li><%= station.site_name %> (<%= link "map", to: "https://maps.google.com/?q=#{station.latitude},#{station.longitude}", target: "_blank" %>):
            <ul>
              <%= for variable <- station.variables do %>
                <li><%= variable.description %>: <%= variable.latest_value_string %></li>
              <% end%>
            </ul>
          </li>
      <% end %> 
    <% else %>
      <li><b>Fetching River Data for the first time...</b></li>
    <% end %>
    """
  end 

end
