
local M = {
    enabled = false
}

-- Identifies what environment the nvim instance is running on,
-- so it can select the focus strategy
-- Supported platforms:
--   - MacOS (uses apple script for focus)
--     - iTerm2
function M.setup()
    local has = vim.fn.has
    local allowedInOS = has("mac") or has("macunix")
    if not allowedInOS then
        return
    end

    M.enabled = true

    local iTermSessionId = vim.env.ITERM_SESSION_ID or ""
    if iTermSessionId ~= "" then
        local iTerm = require("server.terminal.iTerm")
        iTerm.setup(M, iTermSessionId)
        return
    end

    M.enabled = false
end

function M.focus()
    M.terminal:focus()
end

return M
