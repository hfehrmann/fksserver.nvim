---@mod fksserver.terminal Terminal


local terminal = {}

---Abstract class that represents a terminal
---@class Terminal
terminal.Terminal = {}

---Executes the focus operation for the terminal
function terminal.Terminal:focus()
end

---Represents a vanilla terminal
---@class HostingTerminal: Terminal

---Represents a multiplexer terminal. There could be a `HostingTerminal` running
---under the hood
---@class MultiplexerTerminal: Terminal

---Tries to identify the current `Terminal` type that is running
---@return Terminal|nil
function terminal.setup()
    local tmux = require("fksserver.terminal.tmux")

    local terminal = nil

    terminal = tmux.generateIfAvailable()
    if terminal ~= nil then
        return terminal
    end

    local hostingTerminal = require("fksserver.terminal.hosting")
    return hostingTerminal.get("none")
end

return terminal
