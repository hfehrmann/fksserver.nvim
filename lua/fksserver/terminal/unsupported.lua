---Represents an unsupported terminal.
---@class UnsupportedTerminal : Terminal
T = {}
T.__index = T

---@nodoc
function T:new()
    local o = {}
    setmetatable(o, self)
    return o
end

---@nodoc
function T:focus()
end

function T:report_unsupported()
    vim.notify(
        "Unsported terminal configuration.\nRestart or stop the server",
        vim.log.levels.ERROR
    )
end

---Generates UnsupporterTerminal
---@return UnsupportedTerminal
function T.generate()
    return T:new()
end

return T
