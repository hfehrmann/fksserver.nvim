
local M = {
    enabled = false
}

-- Identifies what environment the nvim instance is running on,
-- so it can select the focus strategy
-- Supported platforms:
--   - MacOS (uses apple script for focus
--     - iTerm2
function M.setup()
    local has = vim.fn.has
    local allowedInOS = has("mac") or has("macunix")
    if not allowedInOS then
        return
    end

    local terminalModule = require("fksserver.terminal")
    local terminal = terminalModule.setup()

    M.terminal = terminal
    M.enabled = terminal ~= nil
end

function M.focus()
    M.terminal:focus()
end

return M
