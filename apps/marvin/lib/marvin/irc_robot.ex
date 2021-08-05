defmodule Marvin.IrcRobot do
  @moduledoc """
  Marvin's IRC connection. Sets up and maintains the connection and does misc IRC things.
  There can only be one! (This is a singleton object, methods called on the module find the active PID by name)
  """
  use Hedwig.Robot, otp_app: :marvin
  alias Marvin.PrefrontalCortex, as: STM

  #####
  # Hedwig.Robot Handlers
  #####
  def handle_connect(%{name: name} = state) do
    if :undefined == :global.whereis_name(name) do
      :yes = :global.register_name(name, self())
    end
    Process.send_after(get_pid(), :connection_loop, 15 * 1000) #Start the connection loop in 5 seconds.

    {:ok, state}
  end

  # Don't overwrite, see if Hedwig handles it.
  #def handle_disconnect(_reason, state) do
  #  Logger.debug("Marvin.IrcRobot got IRC disconnect, crashing the process")
  #  raise "Marvin.IrcRobot IRC Disconnected"
  #  {:reconnect, state}
  #end
  
  def handle_in(%Hedwig.Message{} = msg, state) do
    Marvin.PrefrontalCortex.increment(:irc_messages_count)
    {:dispatch, msg, state}
  end

  def handle_in({:joined, channel, %{nick: nick}}, state) do
    mynick = Application.get_env(:marvin, Marvin.IrcRobot)[:name] #TODO: Should this be moved to a variable and only fetched once?
    if mynick == "WA7VC" && channel == "#wa7vc" do
      if nick == "WA7VC-DEV" do
        irc_wa7vc_send("Hello little brother!")
      end
    end
    {:noreply, state}
  end

  def handle_in({:login_failed, :nick_in_use}, state) do
    Logger.error("Could not log in because #{Application.get_env(:marvin, Marvin.IrcRobot)[:name]} is already in use! Multiple developers?!")
    {:noreply, state}
  end

  #def handle_in(_msg, state) do
  #  {:noreply, state}
  #end


  #####
  # Internal Handlers
  #####
  def handle_info(:connection_loop, state) do
    # Logger.debug("Handling :connection_loop")
    last_checked = STM.get(:irc_last_selfping_timestamp)
    mynick = Application.get_env(:marvin, Marvin.IrcRobot)[:name] #TODO: Should this be moved to a variable and only fetched once?

    # Can't use get_client_pid() from inside the genserver loop or it'll time out.
    adapter_pid = Map.get(state, :adapter)
    {_adapter_pid, _adapter_opts, client_pid} = :sys.get_state(adapter_pid)

    # Send ourselves a message as a way to "do something" with the IRC connection.
    # This *should* crashed the process if we're not connected, initiating a restart/reconnect. 
    if last_checked == :error || Timex.diff(Timex.now(), last_checked, :minutes) > 2 do
      ExIRC.Client.msg(client_pid, :privmsg, mynick, "SELFPING-AUTO")
      STM.put(:irc_last_selfping_timestamp, Timex.now())
      STM.put(:irc_connection_status, "Connected")
    end
 
    # If we're still connected (process didn't crash out) we'll update some stats.
    #
    # Note that channel_users() crashes the genserver if called on a channel you're not in, so we have to check first
    case ExIRC.Client.channels(client_pid) do
      {:error, err_atom} -> exit(err_atom)
      channels when is_list(channels) ->
        if Enum.member?(channels, "#wa7vc") do
          STM.put(:irc_users_count, length(ExIRC.Client.channel_users(client_pid, "#wa7vc")))
        end
    end

    schedule_connection_loop()

    {:noreply, state}
  end

  # This would work in the /adapter/, but is not right for the Robot itself
  #  def handle_call(:check_irc_connected, _from, state = {_robot, _opts, client}) do
  #  {:reply, ExIRC.Client.is_connected?(client), state}
  #end
  #def handle_call(:check_irc_connected, _from, opts) do
    #adapter = opts.
    #{:reply, , opts}
  #end

  #####
  # Public API
  #####

  @doc """
    Send a message to #WA7VC as Marvin
  """
  def irc_wa7vc_send(msg) do
    pid = get_pid()
    GenServer.cast(pid, {:send, %Hedwig.Message{room: "#wa7vc", text: msg}})
  end

  @doc """
    Return the PID of Marvin.IrcRobot
  """
  def get_pid() do
    :global.whereis_name(Application.get_env(:marvin, Marvin.IrcRobot)[:name])
  end

  @doc """
    Return the PID of the underlying ExIRC adapter
  """
  def get_client_pid() do
    %{adapter: adapter_pid} = :sys.get_state(get_pid())
    {_adapter_pid, _adapter_opts, client_pid} = :sys.get_state(adapter_pid)
    client_pid
  end

  @doc """
    return the connection state from the IRC Client
  """
  def client_connected?() do
    %{connected?: connection_state} = :sys.get_state(get_client_pid())
    connection_state
  end

  @doc """
    Send ourselevs a message as a way of forcing the underlying ExIRC client to decide if it's currently connected or not
  """
  def selfping() do
    mynick = Application.get_env(:marvin, Marvin.IrcRobot)[:name]

    ExIRC.Client.msg(get_client_pid(), :privmsg, mynick, "SELFPING-MANUAL")
  end

  @doc """
    See if our IRC connection is up
  """
  def is_connected?() do
    GenServer.call(get_client_pid(), :is_connected?)
  end

  @doc """
    Get what channels we're connected to
  """
  def get_channels() do
    ExIRC.Client.channels(get_client_pid())
  end

  @doc """
    Get the channel users for a given channel
  """
  def get_channel_users(channel) do
    ExIRC.Client.channel_users(get_client_pid(), channel)
  end

  @doc """
    Get the channel topic for the given channel
  """
  def get_channel_topic(channel) do
    ExIRC.Client.channel_topic(get_client_pid(), channel)
  end


  #####
  # Interal Helpers
  #####

  defp schedule_connection_loop(), do: Process.send_after(self(), :connection_loop, 60 * 1000)
end
