---@mod fksserver.focus Focus
---@brief [[
---This module identifies the current OS and terminal environment where the
---server is running. The focus command is environment dependent
---@brief ]]

local focus = {}

---Setup the focus envirnoment, querying env data to determine where the
---current Neovim instance is running.
---
---Reports a warning when it is not able to create a focus environemnt
---@return Terminal
function focus.setup()
    local has = vim.fn.has
    local allowedInOS = has("mac") or has("macunix")

    local unsupported = require("fksserver.terminal.unsupported")
    local unsupportedTerminal = unsupported.generate()

    if not allowedInOS then
        vim.notify("Unsoported OS", vim.log.levels.ERROR)
        return unsupportedTerminal
    end

    local terminalModule = require("fksserver.terminal")
    local terminal = terminalModule.setup()

    if terminal == nil then
        terminal = unsupportedTerminal
        terminal:report_unsupported()
    end

    return  terminal
end

return focus
