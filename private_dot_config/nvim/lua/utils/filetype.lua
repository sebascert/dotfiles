local M = {}

local resolvers = {
    { -- shebang
        priority = 1,
        map = function()
            local first_line = vim.fn.getline(1)

            if not string.match(first_line, "^#!") then
                return
            end

            if
                string.match(first_line, "bash")
                or string.match(first_line, "sh")
            then
                return "sh"
            elseif string.match(first_line, "python") then
                return "python"
            end
        end,
    },
    { -- file extension
        priority = 2,
        map = function()
            local buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(buf)

            if string.match(buf_name, "%.h$") then
                return "c"
            elseif string.match(buf_name, "%.hpp$") then
                return "cpp"
            end
        end,
    },
}

---Resolves vim.bo.filetype via resolvers with priority.
---@error Raised on resolver conflict.
function M.resolve_filetype()
    local best_ft = nil
    local best_prio = -math.huge

    for _, resolver in pairs(resolvers) do
        local mapped = resolver.map()
        if mapped ~= nil then
            if resolver.priority > best_prio then
                best_prio = resolver.priority
                best_ft = mapped
            elseif resolver.priority == best_prio and best_ft ~= mapped then
                error("filetype determination conflict")
                error("incompatible " .. best_ft .. " and " .. mapped)
                return
            end
        end
    end

    if best_ft ~= nil then
        vim.bo.filetype = best_ft
    end
end

return M
