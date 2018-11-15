# Marvin
The poor depressed robot.

## Issues
  * Have had trouble with IRC bot staying connected. Can execute this manually via remote console to fix:
    ```
    > pid = :global.whereis_name(Application.get_env(:marvin, Marvin.Robot)[:name])
    > GenServer.cast(pid, {:reconnect})
    ```
