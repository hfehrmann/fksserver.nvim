
local M = {}

function M.setup()
    local tmux = require("server.terminal.tmux")

    local terminal = nil

    terminal = tmux.setupIfAvailable()
    if terminal ~= nil then
        return terminal
    end

    local hostingTerminal = require("server.terminal.hostingTerminal")
    return hostingTerminal.get()
end

return M
