
local M = {}

function M.setup(opts)
    local default_opts = {
        socket_name = "nvim_server",
    }
    local options = vim.tbl_deep_extend("force", default_opts, opts or {})
    local socket_name = options.socket_name
    local sock_format = "/tmp/%s.sock"
    local sock = sock_format:format(socket_name)

    vim.api.nvim_create_user_command(
        "ServerStart",
        function()
            vim.fn.system(
                "nvim --headless --server " .. sock .. " --remote-send \"<C-\\><C-N>: ServerStop<CR><C-\\><C-N>\""
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
        "ServerStop",
        function()
            vim.fn.call(
                "serverstop",
                { sock }
            )
            io.stderr:write("\27]0;nvim\007")
        end,
        {}
    )
end

return M
