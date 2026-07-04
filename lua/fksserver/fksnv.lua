local M = {}

function M.exists()
    return vim.fn.executable("fksnv") == 1
end

function M.check()
    local exists = M.exists()
    if not exists then
        vim.notify("The fksnv shell command is not installed. Install it with FKSInstall.", vim.log.levels.WARN)
    end
end

function M.install()
    local scripts_folders = vim.api.nvim_get_runtime_file("scripts/", true)

    local fksserver_path = ""
    for _, file in ipairs(scripts_folders) do
        if file:find("fksserver.nvim", 1, true) ~= nil then
            fksserver_path = file
            break
        end
    end

    print("TODO: install command")
end

return M
