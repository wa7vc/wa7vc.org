defmodule Wa7vcWeb.DroneChannel do
  use Wa7vcWeb, :channel

  # This is what drones join to submit themselves to Marvin's whims
  @impl true
  def join("drone:cnc", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Each drone gets a unique channel to submit data to Marvin as well.
  # This allows us to address commands to a specific drone easily, without
  # needing to use Presence or anything to track clients.
  @impl true
  def join("drone:"<>_drone_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping-marvin", payload, socket) do
    {:reply, {:ok, payload |> Map.put("pong", "true")}, socket}
  end

  # Ping a specific drone, requesting it to report status
  # If no drone_id is given, broadcast to all drones instead
  @impl true
  def handle_in("ping-drone", %{"drone_id" => drone_id} = payload, socket) do
    #drone_socket = TODO: GET DRONE SOCKET BY drone_id
    #push(drone_socket, "ping", %{})
    {:noreply, socket}
  end

  # If no drone_id was given, broadcast to request all drones report status instead
  @impl true
  def handle_in("ping-drone", _payload, socket) do
    broadcast(socket, "ping", %{})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (drone:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Handle a drone reporting a ping result for a system it monitors
  @impl true
  def handle_in("pinged", %{"target_name" => _target_name,
                            "target_ip" => _target_ip,
                            "success" => _success,
                            "interval" => _interval,
                            "timestamp" => _ts} = _payload, socket) do
    # TODO: Take the payload and drop it into Marvin's brain
    #       - Get the drone_id/drone_hostname from the socket
    #       - Update a counter for number_of_consecutive_seconds_of_success by adding the interval.
    #       - If it was a failure, reset that consectutive_seconds counter to zero
    {:noreply, socket}
  end

  # Handle a drone reporting a new line from a file it tails
  @impl true
  def handle_in("tailed", %{"filename" => _filename,
                            "line" => _line,
                            "timestamp" => _ts} = _payload, socket) do
    # TODO: Take the payload and drop it into Marvin's brain
    #       - Get the drone_id/drone_hostname from the socket
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
