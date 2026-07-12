---@toc fksserver.content
---@mod fksserver Introduction
---@brief [[
---Focus server for nvim.
---
---This plugin creates socket server for nvim. It also provides focusing commands
---that will bring the main Neovim instance to the front of the screen. The
---|fksnv| tool provides a better UX to opening files and focusing into the server.
---
---You can use the socket to send request to the instance directly.
---
---Currently supported OS and terminals:
---
---- MacOS:
---  - iTerm
---    - tmux
---@brief ]]

local M = {}

---Setup fksserver
---@param opts table|nil
---
---All values are optional with below default values. User defined keys
---take preference
---@usage lua [[
---require("fksserver").setup({
---  socket_name = "fks_nvim_server" -- Used by `fksnv` tool. Use -s option to override
---})
---@usage ]]
function M.setup(opts)
    local default_opts = {
        socket_name = "fks_nvim_server",
    }
    local options = vim.tbl_deep_extend("force", default_opts, opts or {})
    local socket_name = options.socket_name
    local sock_format = "/tmp/%s.sock"
    local socket = sock_format:format(socket_name)

    M.opts = {
        socket = socket,
    }
    local focus = require("fksserver.focus")
    local commands = require("fksserver.commands")
    focus.setup()

    commands.register_cmd(M.opts)
end

return M
