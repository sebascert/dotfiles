local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("", { clear = true })

-- highlight on yank
autocmd("TextYankPost", {
    group=group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 50,
        })
    end,
})

-- filetype mappings
local filetype=require("utils.filetype")
autocmd({ "BufRead", "BufNewFile" }, {
    group=group,
    pattern = "*",
    callback = filetype.resolve_filetype
})
