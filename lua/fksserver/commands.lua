---@mod fksserrver.commands Commands
---@brief [[
---Register all the commands for fksserver
---
--- Command          Description
--- ======================================================================
--- *:FKSServerStart*  Starts the server in the current instance
---
--- *:FKSServerStop*   Stops any server running
---
--- *:FKSFocusMe*      Brings the Neovim server into the front, across OS and
---                  terminal windows
---
--- *:FKSOpen*         Open file command
---
--- *:FKSInstall*      Install fksnv tool into the OS system
---@brief ]]

local commands = {}

---Register Neovim commands
function commands.register_cmd(opts)
    local focus = require("fksserver.focus")
    local fksnv = require("fksserver.fksnv")
    local sock = opts.socket

    vim.api.nvim_create_user_command(
        "FKSServerStart",
        function()
            vim.fn.system(
                "nvim --headless --server " .. sock .. " --remote-send \"<C-\\><C-N>:FKSServerStop<CR><C-\\><C-N>\""
            )
            vim.defer_fn(function()
                commands.terminal = focus.setup()
                vim.fn.call(
                    "serverstart",
                    { sock }
                )
                fksnv.check()
                io.stderr:write("\27]0;Main nvim\007")
            end, 500)
        end,
        {}
    )
    vim.api.nvim_create_user_command(
        "FKSServerStop",
        function()
            commands.terminal = nil
            vim.fn.call(
                "serverstop",
                { sock }
            )
            io.stderr:write("\27]0;nvim\007")
        end,
        {}
    )
    vim.api.nvim_create_user_command(
        "FKSFocusMe",
        function()
            if commands.terminal ~= nil then
                commands.terminal:focus()
            else
                vim.notify(
                    "Something went wrong. Restart the focus server",
                    vim.log.levels.ERROR
                )
            end
        end,
        {}
    )
    vim.api.nvim_create_user_command(
        "FKSOpen",
        function(opts)
            local file = vim.fn.fnamemodify(opts.args, ":p")
            local pwd = vim.fn.getcwd() .. "/"

            if file:sub(1, #pwd) == pwd then
                file = file:sub(#pwd + 1)
            end

            vim.cmd("edit " .. file)
        end,
        { nargs = 1 }
    )
    vim.api.nvim_create_user_command(
        "FKSInstall",
        function(opts)
            fksnv.install()
        end,
        {}
    )
end

return commands
