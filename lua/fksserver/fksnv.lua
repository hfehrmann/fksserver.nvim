---@mod fksserver.fksnv fksnv
---@tag fksnv
---@brief [[
---This module checks if the `fksnv` command is installed in the system and provides
---functions for installing it.
---
---Check `fksnv -h` for more information
---@brief ]]

local fksnv = {}

local FKSNV_PATH = "/usr/local/bin/fksnv"

---Checks if `fksnv` comamnd is availabble in the shell
---@return boolean
function fksnv.exists()
    return vim.fn.executable("fksnv") == 1
end

---Checks if `fksnv` command is availabble, and prints a warning if not
---@return void
function fksnv.check()
    local exists = fksnv.exists()
    if not exists then
        vim.notify("The fksnv shell command is not installed. Run FKSInstall.", vim.log.levels.WARN)
    end
end

---Installs the |fksnv| command into /usr/local/bin. This needs sudo access
---@return void
function fksnv.install()
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

    local fksnv_exists = fksnv.exists()
    if fksnv_exists then
        vim.notify("Success!")
    else
        vim.notify("fksnv was not installed.", vim.log.levels.ERROR)
    end
end

return fksnv
