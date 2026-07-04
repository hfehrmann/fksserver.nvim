
iTermFocus = {}
iTermFocus.__index = iTermFocus

function iTermFocus:new(sessionId)
    local o = {}
    setmetatable(o, self)
    self.sessionId = sessionId
    return o
end

function iTermFocus:focus()
    local script = string.format(
        [[
        tell application "iTerm2"
            repeat with w in windows
                set tabIndex to 0
                repeat with t in tabs of w
                    set tabIndex to tabIndex + 1
                    repeat with s in sessions of t
                        set ids to unique id of s
                        if (id of s) is "%s" then
                            activate
                            select tab tabIndex of w
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

function iTermFocus.setup(FOCUS, sessionId)
    local startIndex = string.find(sessionId, ":")
    local realSessionId = ""
    if startIndex then
        realSessionId = string.sub(sessionId, startIndex + 1)
    else
        realSessionId = sessionId
    end

    FOCUS.terminal = iTermFocus:new(realSessionId)
end

return iTermFocus
