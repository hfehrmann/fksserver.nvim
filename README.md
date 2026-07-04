# Fokus Server (fksserver)


## fksnv script

The script sends the open and focus command to the server to the socket.
If there is a server running, it executes those commands

## Configuration

### tmux setup

tmux has a snapshot of the env variables where the the tmux server started.
If a new session starts in a new terminal, it inherits the env variables
from terminal that created the server.

You have to out some options in your config. Update yours as needed
```
set-option -ga update-environment "ITERM_SESSION_ID" # iTerm
```
