
local M = {}

function M.setup()
    local tmux = require("fksserver.terminal.tmux")

    local terminal = nil

    terminal = tmux.setupIfAvailable()
    if terminal ~= nil then
        return terminal
    end

    local hostingTerminal = require("fksserver.terminal.hostingTerminal")
    return hostingTerminal.get()
end

return M
