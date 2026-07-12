---@mod fksserver.terminal.hosting Hosting Terminal
--@brief [[
--This module gets the *Terminal* kinds that are native.
--@biref ]]

local hosting = {}


---Represent the supported Multiplexer types
---@alias MutliplexerType
---| '"tmux"' # tmux multiplexer
---| '"none"' # no multiplexer

---Return the current hosting terminal
---@param multiplexerType MultiplexerType The multiplexer type that wants to
---access the host terminal
---@return HostingTerminal|nil
function hosting.get(multiplexerType)
    local iTerm = require("fksserver.terminal.iTerm")

    terminal = iTerm.generateIfAvailable(multiplexerType)
    if terminal ~= nil then
        return terminal
    end

    return nil
end

return hosting
