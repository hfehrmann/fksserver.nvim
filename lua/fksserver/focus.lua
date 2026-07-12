---@mod fksserver.focus Focus
---@brief [[
---This module identifies the current OS and terminal environment where the
---server is running. The focus command is environment dependent
---@brief ]]

local M = {}

---Setup the focus envirnoment, querying env data to determine where the
---current Neovim instance is running.
---
---Reports a warning when it is not able to create a focus environemnt
function M.setup()
    local has = vim.fn.has
    local allowedInOS = has("mac") or has("macunix")
    if not allowedInOS then
        vim.notify("Unsoported OS", vim.log.levels.ERROR)
        return
    end

    local terminalModule = require("fksserver.terminal")
    local terminal = terminalModule.setup()

    M.terminal = terminal

    if terminal == nil then
        report_unsupported()
    end
end

---Executes the focus command for the identified terminal mode. This method
---requires a call to `M.setup()` to work.
function M.focus()
    if M.terminal == nil then
        report_unsupported()
        return
    end

    M.terminal:focus()
end

function report_unsupported()
    vim.notify(
        "Unsported terminal configuration.\nRestart or stop the server",
        vim.log.levels.ERROR
    )
end

return M
