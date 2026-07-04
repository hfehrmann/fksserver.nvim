
local M = {}

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
    focus.setup()

    register_cmd()
end

function register_cmd()
    local focus = require("fksserver.focus")
    local sock = M.opts.socket

    vim.api.nvim_create_user_command(
        "FKSServerStart",
        function()
            focus.setup()
            vim.fn.system(
                "nvim --headless --server " .. sock .. " --remote-send \"<C-\\><C-N>:FKSServerStop<CR><C-\\><C-N>\""
            )
            vim.defer_fn(function()
                vim.fn.call(
                    "serverstart",
                    { sock }
                )
                io.stderr:write("\27]0;Main nvim\007")
            end, 500)
        end,
        {}
    )
    vim.api.nvim_create_user_command(
        "FKSServerStop",
        function()
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
            focus.focus()
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
end

return M
