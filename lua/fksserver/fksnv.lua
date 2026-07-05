local M = {}

local FKSNV_PATH = "/usr/local/bin/fksnv"

function M.exists()
    return vim.fn.executable("fksnv") == 1
end

function M.check()
    local exists = M.exists()
    if not exists then
        vim.notify("The fksnv shell command is not installed. Run FKSInstall.", vim.log.levels.WARN)
    end
end

function M.install()
    local scripts_folders = vim.api.nvim_get_runtime_file("scripts/", true)

    local fksserver_path = nil
    for _, file in ipairs(scripts_folders) do
        if file:find("fksserver.nvim", 1, true) ~= nil then
            fksserver_path = file
            break
        end
    end

    if fksserver_path == nil then
        vim.notify("Couldn't find fksserver.nvim plugin path", vim.log.levels.ERROR)
        return
    end
    local fksnv_script = fksserver_path .. "fksnv.sh"

    local warning = "" ..
        "You are about to install the fksnv binary into " .. FKSNV_PATH .. "\n" ..
        "This requires sudo access."
    print(warning)

    local password = vim.fn.inputsecret("Password: ")
    vim.cmd("redraw!") -- Clear command line

    if password == "" then
        vim.notify("No password provided.", vim.log.levels.WARN)
        return
    end

    vim.fn.system({ "sudo", "-S", "ln", "-s", fksnv_script, FKSNV_PATH }, password)

    local fksnv_exists = M.exists()
    if fksnv_exists then
        vim.notify("Success!")
    else
        vim.notify("fksnv was not installed.", vim.log.levels.ERROR)
    end
end

return M
