defmodule Wa7vcWeb.MarvinLive do
  use Wa7vcWeb, :live_view

  @impl true
  def mount(_params, _session, socket)  do
    assigns = Map.new()
              |> Map.put(:query, "")
              |> Map.put(:results, %{})
              |> Map.merge(marvin_assigns())
              |> Map.put(:meta_attrs, [ %{name: "robots", content: "noindex"},
                                        %{name: "description", content: "Statistics and interesting facts, with a healthy dose of depression."} ])

    if connected?(socket), do: :timer.send_interval(1000, self(), :update_lifespans)

    # Subscribe to Marvin's memory.
    Phoenix.PubSub.subscribe(Wa7vc.PubSub, "prefrontal_cortex")

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_info(:update_lifespans, socket) do
    {:noreply, assign(socket, lifespan_assigns(Enum.member?(Node.list(), :"marvin@127.0.0.1")))}
  end

  # Handle key update broadcasts from Marvin.PrefrontalCortex
  # Any key we already have an assigns for gets updated, anything else gets ignored.
  # So to get live assigns updating, just add the variable to assigns on mount, and presto!
  # Because it is implicit that these updates are sent by Marvin, if Marvin is
  # currently AFK we can set him back to active and uptade *all* the data.
  def handle_info(%{event: "key:updated", payload: %{:key => k, :value => v}}, socket) do
    if !socket.assigns.marvin_active do
      ^socket = assign(socket, marvin_assigns())
    else
      case Map.has_key?(socket.assigns, k) do
        true ->
          {:noreply, assign(socket, %{k => v})}
        false ->
          {:noreply, socket}
      end
    end
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply,
      socket
      |> put_flash(:error, "No results found. Am I even trying?")
      |> assign(results: %{}, query: query)}
  end

  defp get_key_from_marvin(key) do
    {:ok, res} = GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, key}) 
    res
  end

  defp get_counter_from_marvin(key) do
    {:ok, res} = GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, key}) 
    res
  end

  defp marvin_assigns() do
    marvin_present = Enum.member?(Node.list(), :"marvin@127.0.0.1")

    Map.new()
    |> Map.merge(marvin_active_assign(marvin_present))
    |> Map.merge(version_assigns(marvin_present))
    |> Map.merge(lifespan_assigns(marvin_present))
    |> Map.merge(leftover_assigns(marvin_present))
  end

  defp marvin_active_assign(marvin_present) do
    %{marvin_active: marvin_present}
  end

  defp lifespan_assigns(marvin_present) do
    if marvin_present do
      %{marvin_lifespan_seconds_since_launch: get_key_from_marvin(:seconds_since_launch),
        marvin_lifespan_marvinyears_since_launch: get_key_from_marvin(:marvinyears_since_launch),
        marvin_lifespan_last_started: get_key_from_marvin(:last_started),
        marvin_lifespan_marvinyears_since_last_started: get_key_from_marvin(:marvinyears_since_last_started)
      }
    else
      %{marvin_lifespan_seconds_since_launch: 0,
        marvin_lifespan_marvinypears_since_launch: 0,
        marvin_lifespan_last_started: "[[ UNKNOWN - Marvin was AWOL ]]",
        marvin_lifespan_marvinyears_since_last_started: 0
      }
    end
  end

  defp version_assigns(_marvin_present) do
    #List.to_string(vsn_wa7vc_web)
    {:ok, vsn_wa7vc} = :application.get_key(:wa7vc, :vsn)
    #List.to_string(vsn_wa7vc)
    vsn_marvin = case :rpc.call(:"marvin@127.0.0.1", Marvin, :version, []) do
      {:badrpc, :nodedown} -> "[[ UNKNOWN - Marvin was AWOL ]]"
      v -> v
    end
    #List.to_string(vsn_marvin)

    %{wa7vc_version: vsn_wa7vc, marvin_version: vsn_marvin}
  end


  defp leftover_assigns(marvin_present) do
    if marvin_present do
      %{irc_users_count: get_counter_from_marvin(:irc_users_count),
        irc_interactions_count: get_counter_from_marvin(:irc_interactions_count),
        irc_messages_count: get_counter_from_marvin(:irc_messages_count),
        github_pushes_with_commits_count: get_counter_from_marvin(:github_pushes_with_commits_count),
        github_commits_count: get_counter_from_marvin(:github_commits_count),
        github_webhook_count: get_counter_from_marvin(:github_webhook_count),
        usgs_river_data_fetches_count: get_counter_from_marvin(:usgs_river_data_fetches_count),
        usgs_river_data_latest_fetch_timestamp: get_key_from_marvin(:usgs_river_data_latest_fetch_timestamp),
        usgs_river_data_latest: get_key_from_marvin(:usgs_river_data_latest),
        aprs_messages_parsed_count: get_counter_from_marvin(:aprs_messages_parsed_count)
      }
    else
      %{irc_users_count: 0,
        irc_interactions_count: 0,
        irc_messages_count: 0,
        github_pushes_with_commits_count: 0,
        github_commits_count: 0,
        github_webhook_count: 0,
        usgs_river_data_fetches_count: 0,
        usgs_river_data_latest_fetch_timestamp: "[[ UNKNOWN - Marvin was AWOL ]]",
        usgs_river_data_latest: nil,
        aprs_messages_parsed_count: 0
      }
    end
  end
end
