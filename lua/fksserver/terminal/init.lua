---@mod fksserver.terminal Terminal

---Abstract class that represents a terminal
---@class Terminal
local Terminal = {}

---Executes the focus operation for the terminal
function Terminal:focus()
end

---Represents a vanilla terminal
---@class HostingTerminal: Terminal

---Represents a multiplexer terminal. There could be a `HostingTerminal` running
---under the hood
---@class MultiplexerTerminal: Terminal

local M = {}

---Tries to identify the current `Terminal` type that is running
---@return Terminal|nil
function M.setup()
    local tmux = require("fksserver.terminal.tmux")

    local terminal = nil

    terminal = tmux.generateIfAvailable()
    if terminal ~= nil then
        return terminal
    end

    local hostingTerminal = require("fksserver.terminal.hostingTerminal")
    return hostingTerminal.get("none")
end

return M
