defmodule Wa7vcWeb.DroneChannelTest do
  use Wa7vcWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      Wa7vcWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(Wa7vcWeb.DroneChannel, "drone:cnc")

    %{socket: socket}
  end

  test "reply to ping requsets with status ok, and the given payload with pong=true ammended", %{socket: socket} do
    ref = push(socket, "ping-marvin", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there", "pong" => "true"}
  end

  test "request to ping a specific drone pushes to that drone only on drone:cnc" do
    assert false
  end

  test "request to ping a drone with no drone_id broadcasts ping request to all drones on drone:cnc" do
    assert false
  end

  test "shout broadcasts to all drones", %{socket: socket} do
    push(socket, "shout", %{"hello" => "all"})
    assert_broadcast "shout", %{"hello" => "all"}
    # TODO: Test that a drone connected to drone:DRONE_ID topic sending a shout
    #       correctly shouts to all drones in the drone:cnc topic
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end

  test "puts a ping result into Marvin's memory", %{socket: socket} do
    push(socket, "pinged", %{"target_name"=>"moose",
                             "target_ip"=>"10.9.8.7",
                             "success"=>"true",
                             "interval"=>"5",
                             "timestamp"=>"2020-12-31T23:59:59Z"})
    # TODO: Validate it put it into Marvin's PFC
    #assert_broadcast "result", %{"hello" => "all", "shouted" => "true"}
  end

  test "puts a tailed line into Marvin's memory", %{socket: socket} do
    push(socket, "tailed", %{"filename" => "dstar.log",
                             "line"=>"this is a new line",
                             "timestamp"=>"2020-12-31T23:59:59Z"})
    # TODO: Validate it put it into the Marvin's PFC
    #assert_broadcast "result", %{"hello" => "all", "shouted" => "true"}
  end
end
