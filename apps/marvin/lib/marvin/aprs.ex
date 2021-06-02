defmodule Marvin.Aprs do
  @moduledoc """
  Monitor APRS beacons in the area of Valley Camp, using a connection to the APRS-IS network to get packets.

  Based on [aprsEx by Matt-Hornsby](https://github.com/Matt-Hornsby/aprsEx)
  """

  use GenServer
  require Logger
  alias Marvin.PrefrontalCortex, as: STM
  alias Aprs.Parser

  @aprs_timeout 30_000     # 1000 * 30, timeout after 30 seconds

  #######
  # SETUP

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_args) do
    Process.flag(:trap_exit, true) # Dispatch to terminate/2 callback for exit

    server = Application.get_env(:marvin, Marvin.Aprs)[:server]
    port = Application.get_env(:marvin, Marvin.Aprs)[:port]
    filter = Application.get_env(:marvin, Marvin.Aprs)[:filter]
    aprs_login = Application.get_env(:marvin, Marvin.Aprs)[:aprs_login]
    aprs_passcode = Application.get_env(:marvin, Marvin.Aprs)[:aprs_passcode]

    with {:ok, socket} <- connect_to_aprs_is(server, port),
         :ok <- send_login_string(socket, aprs_login, aprs_passcode, filter),
         timer <- create_timer(@aprs_timeout) do
      {:ok, 
        %{server: server,
          port: port,
          socket: socket,
          timer: timer
      }}
    else
      _ -> 
        Logger.error("Could not connect or log in to APRS-IS")
        {:stop, :aprs_connection_failed}
    end
  end

  ############
  # Client API

  def stop() do
    Logger.info("Stopping Server")
    GenServer.stop(__MODULE__, :stop)
  end

  def list_active_filters(), do: send_message("#filter? ")

  def set_filter(filter_string), do: send_message("#filter #{filter_string}")

  def send_message(from, to, message) do
    padded_callsign = String.pad_trailing(to, 9)
    send_message("#{from}>APRS,TCPIP*::#{padded_callsign}:#{message}")
  end

  def send_message(message) do
    GenServer.call(__MODULE__, {:send_message, message})
  end

  def handle_aprs_beacon_1hr_cache_callback(data) do
    IO.inspect(data)
    Marvin.PrefrontalCortex.put(:aprs_beacons_1hr_count, ConCache.size(:aprs_beacon_1hr_cache))
  end


  ############
  # Server API

  def handle_call({:send_message, message}, _from, state) do
    next_ack_number = STM.increment(:aprs_ack_number)
    message = message <> "{" <> to_string(next_ack_number) <> "\r"
    :gen_tcp.send(state.socket, message)
    {:reply, :ok, state}
  end

  def handle_info({:tcp, _socket, packet}, state) do
    STM.increment(:aprs_messages_parsed_count)
    Process.cancel_timer(state.timer)
    dispatch(packet)
    timer = Process.send_after(self(), :aprs_no_message_timeout, @aprs_timeout)

    {:noreply, %{ state | timer: timer}}
  end

  def handle_info(:aprs_no_message_timeout, state) do
    Logger.error("APRS-IS socket connection timed out, killing genserver")
    {:stop, :aprs_timeout, state}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    Logger.error("APRS-IS socket closed")
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    Logger.error("APRS-IS socket closed due to error #{inspect(reason)}")
    {:stop, :normal, state}
  end

  def terminate(reason, state) do
    Logger.info("Marvin.APRS going down: #{inspect(reason)} - #{inspect(state)}")
 
    # Write out any state that needs saving
    
    :gen_tcp.close(state.socket)

    :normal
  end

  def dispatch("#" <> comment_text) do
    Logger.debug("APRS-IS COMMENT: " <> String.trim(comment_text))
  end

  def dispatch(message) do
    m = Parser.parse(message)
    Logger.debug("APRS-IS message being dispatched: #{inspect(m)}")

    #m has base_callsign, sender, and ssid, as well as path, destination, and information_field (raw string)
    #information_field starting with ";IRLP-7808" on a message with data_type :object appears to be the IRLP Beacon
    # data_type :object, sender of WA7VC-S, information_field: ";WA7VC  B"etc
    # data_type: position, sender: WA7VC-B
    # data_type: position, sender: WA7VC-10
    # data_type: telemetry, sender: WA7VC-10, information_field has the telemetry data
    #

    case m.base_callsign do
      "WA7VC" -> nil
      _ -> ConCache.put(:aprs_beacon_1hr_cache, m.base_callsign, m)
    end

    # Any other handling we want to do for this message?
  end

  defp connect_to_aprs_is(server, port) do
    opts = [:binary, active: true]
    :gen_tcp.connect(server, port, opts)
  end

  defp send_login_string(socket, aprs_login, aprs_passcode, filter) do
    :gen_tcp.send(socket, "user #{aprs_login} pass #{aprs_passcode} vers Marvin 0.3 filter #{filter} \n")
  end

  defp create_timer(timeout) do
    Process.send_after(self(), :aprs_no_message_timeout, timeout)
  end

end
