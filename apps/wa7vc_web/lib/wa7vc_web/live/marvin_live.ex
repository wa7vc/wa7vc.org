defmodule Wa7vcWeb.MarvinLive do
  use Wa7vcWeb, :live_view

  @impl true
  def mount(_params, _session, socket)  do
    assigns = Map.new()
              |> Map.put(:query, "")
              |> Map.put(:results, %{})
              |> Map.merge(version_assigns())
              |> Map.merge(lifespan_assigns())
              |> Map.merge(leftover_assigns())
              |> Map.put(:meta_attrs, [ %{name: "robots", content: "noindex"},
                                        %{name: "description", content: "Statistics and interesting facts, with a healthy dose of depression."} ])

    if connected?(socket), do: :timer.send_interval(1000, self(), :update_lifespans)

    Marvin.PrefrontalCortex.subscribe()

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_info(:update_lifespans, socket) do
    {:noreply, assign(socket, lifespan_assigns())}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply,
      socket
      |> put_flash(:error, "No results found. Am I even trying?")
      |> assign(results: %{}, query: query)}
  end

  # Handle key update broadcasts from Marvin.PrefrontalCortex
  # Any key we already have an assigns for gets updated, anything else gets ignored.
  # So to get live assigns updating, just add the variable to assigns on mount, and presto!
  def handle_info({:key_updated, {k,v}}, socket) do
    case Map.has_key?(socket.assigns, k) do
      true ->
        {:noreply, assign(socket, %{k => v})}
      false ->
        {:noreply, socket}
    end
  end


  defp lifespan_assigns() do
    %{marvin_lifespan_seconds_since_launch: Marvin.Application.since_released(:seconds) |> Number.Delimit.number_to_delimited(precision: 0),
      marvin_lifespan_human_years_since_launch: Marvin.Application.since_released(:marvinyears) |> Number.Human.number_to_human,
      marvin_lifespan_seconds_since_last_started: Marvin.Application.last_started() |> Timex.format!("%F at %T %Z", :strftime),
      marvin_lifespan_human_years_since_last_started: Marvin.Application.lifespan(:marvinyears) |> Number.Human.number_to_human(precision: 0) }
  end


  # TODO: Detect when a new version has been released so the new version numbers can get pushed?
  defp version_assigns() do
    # Get application version numbers
    {:ok, vsn_wa7vc_web} = :application.get_key(:wa7vc_web, :vsn)
    #List.to_string(vsn_wa7vc_web)
    {:ok, vsn_wa7vc} = :application.get_key(:wa7vc, :vsn)
    #List.to_string(vsn_wa7vc)
    {:ok, vsn_marvin} = :application.get_key(:marvin, :vsn)
    #List.to_string(vsn_marvin)

    %{wa7vc_web_version: vsn_wa7vc_web, wa7vc_version: vsn_wa7vc, marvin_version: vsn_marvin}
  end


  defp leftover_assigns() do
    %{irc_users_count: Marvin.PrefrontalCortex.getcounter(:irc_users_count),
      irc_interactions_count: Marvin.PrefrontalCortex.getcounter(:irc_interactions_count),
      irc_messages_count: Marvin.PrefrontalCortex.getcounter(:irc_messages_count),
      github_pushes_with_commits_count: Marvin.PrefrontalCortex.getcounter(:github_pushes_with_commits_count),
      github_pushes_count: Marvin.PrefrontalCortex.getcounter(:github_pushes_count) }
  end
end
