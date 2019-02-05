defmodule Marvin.IrcRobot do
  use Hedwig.Robot, otp_app: :marvin
  alias Marvin.PrefrontalCortex, as: STM

  #####
  # Hedwig.Robot Handlers
  #####
  def handle_connect(%{name: name} = state) do
    if :undefined == :global.whereis_name(name) do
      :yes = :global.register_name(name, self())
    end
    STM.put(:irc_last_checked, Timex.now())
    schedule_connection_check()

    {:ok, state}
  end

  def handle_disconnect(_reason, state) do
    Logger.debug("Marvin.IrcRobot got IRC disconnect, crashing the process")
    raise "Marvin.IrcRobot IRC Disconnected"
    {:reconnect, state}
  end

  def handle_in(%Hedwig.Message{} = msg, state) do
    {:dispatch, msg, state}
  end

  def handle_in({:joined, channel, %{nick: nick}}, state) do
    mynick = Application.get_env(:marvin, Marvin.IrcRobot)[:name] #TODO: Should this be moved to a variable and only fetched once?
    if mynick == "WA7VC" && channel == "#wa7vc" do
      if nick == "WA7VC-DEV" do
        wa7vc_send("Hello little brother!")
      end
    end
    {:noreply, state}
  end

  def handle_in(_msg, state) do
    {:noreply, state}
  end


  #####
  # Internal Handlers
  #####
  def handle_info(:connection_check_loop, state) do
    last_checked = STM.get(:irc_last_checked)
    if Timex.diff(last_checked, Timex.now(), :minutes) > 3 do
      adapter_pid = Map.get(state, :adapter)
      {_adapter_pid, _adapter_opts, client_pid} = :sys.get_state(adapter_pid)
      mynick = Application.get_env(:marvin, Marvin.IrcRobot)[:name] #TODO: Should this be moved to a variable and only fetched once?
      ExIrc.Client.msg(client_pid, :privmsg, mynick, "SELFPING-AUTO")
      # This *should* initiate a crash/reboot if we're not connected

      STM.put(:irc_last_checked, Timex.now())
      schedule_connection_check()
    end
    {:noreply, state}
  end


  #####
  # Public API
  #####

  def wa7vc_send(msg) do
    pid = get_pid()
    GenServer.cast(pid, {:send, %Hedwig.Message{room: "#wa7vc", text: msg}})
  end

  def get_pid() do
    :global.whereis_name(Application.get_env(:marvin, Marvin.IrcRobot)[:name])
  end

  def get_client_pid() do
    %{adapter: adapter_pid} = :sys.get_state(get_pid())
    {_adapter_pid, _adapter_opts, client_pid} = :sys.get_state(adapter_pid)
    client_pid
  end

  def client_connected?() do
    %{connected?: connection_state} = :sys.get_state(get_client_pid())
    connection_state
  end

  # Send ourselevs a message as a way of forcing the ExIrc client to decide if it's currently connected or not
  def selfping() do
    mynick = Application.get_env(:marvin, Marvin.IrcRobot)[:name]
    ExIrc.Client.msg(get_client_pid(), :privmsg, mynick, "SELFPING-MANUAL")
  end

  #####
  # Interal Helpers
  #####


  defp schedule_connection_check(), do: Process.send_after(self(), :connection_check_loop, 60 * 1000)
end
