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

    # Subscribe Marvin's memory.
    Phoenix.PubSub.subscribe(Wa7vc.PubSub, "prefrontal_cortex")

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_info(:update_lifespans, socket) do
    {:noreply, assign(socket, lifespan_assigns())}
  end

  # Handle key update broadcasts from Marvin.PrefrontalCortex
  # Any key we already have an assigns for gets updated, anything else gets ignored.
  # So to get live assigns updating, just add the variable to assigns on mount, and presto!
  def handle_info(%{event: "key:updated", payload: %{:key => k, :value => v}}, socket) do
    case Map.has_key?(socket.assigns, k) do
      true ->
        {:noreply, assign(socket, %{k => v})}
      false ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply,
      socket
      |> put_flash(:error, "No results found. Am I even trying?")
      |> assign(results: %{}, query: query)}
  end



  defp lifespan_assigns() do
    seconds_since_released = case GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, :seconds_since_released}) do
      {:ok, sec} -> sec |> Number.Delimit.number_to_delimited(precision: 0)
      _ -> "[[ UNKNOWN - Marvin is AWOL ]]"
    end

    marvinyears_since_released = case GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, :seconds_since_released}) do
      {:ok, years} -> years |> Number.Human.number_to_human
      _ -> "[[ UNKNOWN - Marvin is AWOL ]]"
    end

    last_started = case GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, :last_started}) do
      {:ok, started} -> started |> Timex.format!("%F at %T %Z", :strftime)
      _ -> "[[ UNKNOWN - Marvin is AWOL ]]"
    end

    marvinyears_lifespan = case GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, :marvinyears_lifespan}) do
      {:ok, marvinyears} -> marvinyears |> Number.Human.number_to_human(precision: 0) 
      _ -> "[[ UNKNOWN - Marvin is AWOL ]]"
    end

    %{marvin_lifespan_seconds_since_launch: seconds_since_released,
      marvin_lifespan_human_years_since_launch: marvinyears_since_released,
      marvin_lifespan_seconds_since_last_started: last_started,
      marvin_lifespan_human_years_since_last_started: marvinyears_lifespan }
  end


  # TODO: Detect when a new version has been released so the new version numbers can get pushed?
  defp version_assigns() do
    #List.to_string(vsn_wa7vc_web)
    {:ok, vsn_wa7vc} = :application.get_key(:wa7vc, :vsn)
    #List.to_string(vsn_wa7vc)
    vsn_marvin = case :rpc.call(:"marvin@127.0.0.1", Marvin, :version, []) do
      {:badrpc, :nodedown} -> "[[ UNKNOWN - Marvin is AWOL ]]"
      v -> v
    end
    #List.to_string(vsn_marvin)

    %{wa7vc_version: vsn_wa7vc, marvin_version: vsn_marvin}
  end


  defp leftover_assigns() do
    with {:ok, irc_users_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :irc_users_count}),
         {:ok, irc_interactions_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :irc_interactions_count}),
         {:ok, irc_messages_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :irc_messages_count}),
         {:ok, github_pushes_with_commits_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :github_pushes_with_commits_count}),
         {:ok, github_pushes_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :github_pushes_count}),
         {:ok, usgs_river_data_fetches_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :usgs_river_data_fetches_count}),
         {:ok, usgs_river_data_latest_fetch_timestamp} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, :usgs_river_data_latest_fetch_timestamp}),
         {:ok, usgs_river_data_latest} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get, :usgs_river_data_latest}),
         {:ok, aprs_messages_parsed_count} <- GenServer.call({Marvin.PrefrontalCortex, :"marvin@127.0.0.1"}, {:get_counter, :aprs_messages_parsed_count})
    do
      %{irc_users_count: irc_users_count,
        irc_interactions_count: irc_interactions_count,
        irc_messages_count: irc_messages_count,
        github_pushes_with_commits_count: github_pushes_with_commits_count,
        github_pushes_count: github_pushes_count,
        usgs_river_data_fetches_count: usgs_river_data_fetches_count |> Number.Human.number_to_human(precision: 0),
        usgs_river_data_latest_fetch_timestamp: usgs_river_data_latest_fetch_timestamp,
        usgs_river_data_latest: usgs_river_data_latest,
        aprs_messages_parsed_count: aprs_messages_parsed_count
      }
    else
      _ -> %{irc_users_count: "[[ UNKNOWN - Marvin is AWOL ]]",
              irc_interactions_count: "[[ UNKNOWN - Marvin is AWOL ]]",
              irc_messages_count: "[[ UNKNOWN - Marvin is AWOL ]]",
              github_pushes_with_commits_count: "[[ UNKNOWN - Marvin is AWOL ]]",
              github_pushes_count: "[[ UNKNOWN - Marvin is AWOL ]]",
              usgs_river_data_fetches_count: "[[ UNKNOWN - Marvin is AWOL ]]",
              usgs_river_data_latest_fetch_timestamp: "[[ UNKNOWN - Marvin is AWOL ]]",
              usgs_river_data_latest: nil,
              aprs_messages_parsed_count: "[[ UNKNOWN - Marvin is AWOL ]]"
            }
    end
  end
end
