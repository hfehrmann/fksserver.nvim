---@mod fksserver.terminal.iTerm iTerm

---Represents an iTerm terminal
---@class iTerm: HostingTerminal
T = {}
T.__index = T

---@nodoc
function T:new(sessionId)
    local o = {}
    setmetatable(o, self)
    self.sessionId = sessionId
    return o
end

---@nodoc
function T:focus()
    local script = string.format(
        [[
        tell application "iTerm"
            set targetSessionId to "%s"
            repeat with w in windows
                repeat with t in tabs of w
                    set idList to id of sessions of t
                    set matchIndex to 0
                    repeat with i from 1 to count of idList
                        if item i of idList is targetSessionId then
                            set matchIndex to i
                            exit repeat
                        end if
                    end repeat

                    if matchIndex > 0 then
                        select t
                        select w
                        select (item matchIndex of (sessions of t))
                        activate
                        return
                    end if
                end repeat
            end repeat
        end tell
        ]],
        self.sessionId
    )
    vim.system({"osascript", "-e", script}, function() end)
end


---Tries to generate an iTerm terminal if the environment supports it. It might
---be running a multiplexer, so it needs to be aware of the kind
---@param multiplexerType MutliplexerType the type of the running multiplexer
---@return iTerm|nil
function T.generateIfAvailable(multiplexerType)
    local sessionId = ""

    if multiplexerType == "tmux" then
        local result = vim.fn.system("tmux showenv ITERM_SESSION_ID")
        if result:sub(1, 1) == "-" then
            return nil
        end

        local index = result:find("=")
        if index == nil then
            vim.notify(
                "iTerm + tmux detected, but env misconfigured. Check your system.",
                vim.log.levels.WARN
            )
        end
        sessionId = result:sub(index + 1):gsub("%s+", "")
    else
        sessionId = vim.env.ITERM_SESSION_ID or ""
        if sessionId == "" then
            return nil
        end
    end

    local startIndex = string.find(sessionId, ":")
    local realSessionId = ""
    if startIndex then
        realSessionId = string.sub(sessionId, startIndex + 1)
    else
        realSessionId = sessionId
    end

    return T:new(realSessionId)
end

return T
