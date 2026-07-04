
iTerm = {}
iTerm.__index = iTerm

function iTerm:new(sessionId)
    local o = {}
    setmetatable(o, self)
    self.sessionId = sessionId
    return o
end

function iTerm:focus()
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
    local cmd = "osascript -e " .. vim.fn.shellescape(script)
    local out = vim.fn.system(cmd)
end

function iTerm.setupIfAvailable(multiplexerType)
    local sessionId = ""

    if multiplexerType == "tmux" then
        local result = vim.fn.system("tmux showenv ITERM_SESSION_ID")
        if result:sub(1, 1) == "-" then
            return nil
        end

        local index = result:find("=")
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

    return iTerm:new(realSessionId)
end

return iTerm
