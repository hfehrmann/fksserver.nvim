---@mod  fksserver.terminal.tmux Tmux

---Represents a tmux terminal.
---@class Tmux : MultiplexerTerminal
T = {}
T.__index = T

---@nodoc
function T:new(paneId)
    local o = {}
    setmetatable(o, self)
    self.paneId = paneId
    return o
end

---@nodoc
function T:focus()

    local window_script = string.format(
        [[
        tmux list-panes -a -F '#D:#I' | grep '%s' | sed 's|.*:||'
        ]],
        self.paneId
    )
    local window = vim.fn.system(window_script)
    local focus_script = string.format(
        [[
        tmux selectw -t %s; \
        tmux selectp -t %s
        ]],
        window,
        self.paneId
    )
    vim.fn.system(focus_script)

    local hostingTerminal = require("fksserver.terminal.hostingTerminal")
    local terminal = hostingTerminal.get("tmux")
    if terminal then
        terminal:focus()
    end
end

---Tries to generate a tmux terminal if the environment supports it
---@return Tmux|nil
function T.generateIfAvailable()
    local paneId = vim.env.TMUX_PANE

    if paneId then
        return T:new(paneId)
    else
        return nil
    end
end

return T
