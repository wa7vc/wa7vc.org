# Marvin
The poor depressed robot.

## Issues
  * Have had trouble with IRC bot staying connected. Can execute this manually via remote console to fix:
    ```
    > GenServer.cast(Marvin.IrcRobot.get_pid(), {:reconnect})
    ```
