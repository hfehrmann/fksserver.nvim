
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
        tell application "iTerm2"
            repeat with w in windows
                set tabIndex to 0
                repeat with t in tabs of w
                    set tabIndex to tabIndex + 1
                    repeat with ses in sessions of t
                        if (id of ses) is "%s" then
                            activate
                            select tab tabIndex of w
                            select ses
                            return
                        end if
                    end repeat
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
