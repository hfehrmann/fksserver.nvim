
local M = {}

function M.get(multiplexerType)
    local iTerm = require("server.terminal.iTerm")

    terminal = iTerm.setupIfAvailable(multiplexerType)
    if terminal ~= nil then
        return terminal
    end

    vim.notify("The hosting terminal is not supported", vim.log.levels.ERROR)
    return nil
end

return M
