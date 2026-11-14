local ok, err = pcall(function()
    require("lazy").restore({ wait = true, show = false })

    local registry = require("mason-registry")
    registry.refresh()

    local lockfile = vim.fn.stdpath("config") .. "/mason-lock.json"
    local versions =
        vim.json.decode(table.concat(vim.fn.readfile(lockfile), "\n"))
    require("mason-lock").restore_from_lockfile()

    for name, version in pairs(versions) do
        local package = registry.get_package(name)
        assert(
            package:is_installed()
                and package:get_installed_version() == version,
            "Failed to restore " .. name .. "@" .. version
        )
    end
end)

if not ok then
    vim.api.nvim_err_writeln(tostring(err))
    vim.cmd("cquit")
end

vim.cmd("qa")
