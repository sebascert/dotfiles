local M={}

local resolvers = {
    { -- shebang
        priority = 1,
        map = function()
            local first_line = vim.fn.getline(1)

            if not string.match(first_line, "^#!") then
                return
            end

            if string.match(first_line, "bash") or
                string.match(first_line, "sh") then
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
---@error Raised on resolver's conflict.
function M.resolve_filetype()
        local filetype = ""
        local priority = 0

        for _, mapping in pairs(resolvers) do
            if mapping.priority < priority then
                goto continue
            end

            local mapped = mapping.map()
            if mapped == nil then
                goto continue
            end

            if mapping.priority > priority then
                priority = mapping.priority
                filetype = mapped
            elseif mapping.priority == priority then
                if filetype == mapped then
                    goto continue
                end

                error("filetype determination conflict")
                error("incompatible " .. filetype " and " .. mapped)
                return
            end
            ::continue::
        end

        if priority ~= 0 then
            vim.bo.filetype = filetype
        end
    end

return M
