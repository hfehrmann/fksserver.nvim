---@mod fksserver.terminal.macTerminal Mac Terminal

---Represents an MacTerminal terminal
---@class MacTerminal: HostingTerminal
T = {}
T.__index = T

---@nodoc
function T:new(tty)
    local o = {}
    setmetatable(o, self)
    self.tty = tty
    return o
end

---@nodoc
function T:focus()
    local script = string.format(
        [[
        tell application "Terminal"
            set targetTTY to "%s"
            set winList to windows
            repeat with w in winList
                set tabList to tabs of w
                repeat with t in tabList
                    if tty of t is targetTTY then
                        set selected of t to true
                        set index of w to 1
                        activate
                        return
                    end if
                end repeat
            end repeat
        end tell
        ]],
        self.tty
    )
    vim.system({"osascript", "-e", script}, function() end)
end


---Tries to generate a Mac Terminal terminal if the environment supports it.
---It might be running a multiplexer, so it needs to be aware of the kind
---@param multiplexerType MutliplexerType the type of the running multiplexer
---@return MacTerminal|nil
function T.generateIfAvailable(multiplexerType)
    local tty = ""

    if multiplexerType == "tmux" then
        local session = vim.fn.system("tmux showenv TERM_SESSION_ID")
        if session:sub(1, 1) == "-" then
            return nil
        end

        local result = vim.fn.system("tmux showenv FKSSERVER_TTY")
        if result:sub(1, 1) == "-" then
            return nil
        end

        local index = result:find("=")
        if index == nil then
            vim.notify(
                "Mac terminal + tmux detected, but env misconfigured. Check your system.",
                vim.log.levels.WARN
            )
        end
        tty = result:sub(index + 1):gsub("%s+", "")
    else
        local session = vim.env.TERM_SESSION_ID or ""
        if session == "" then
            return nil
        end

        tty = vim.env.FKSSERVER_TTY or ""
        if tty == "" then
            vim.notify(
                "Mac terminal detected, but env misconfigured. Check your system.",
                vim.log.levels.WARN
            )
            return nil
        end
    end

    return T:new(tty)
end

return T
