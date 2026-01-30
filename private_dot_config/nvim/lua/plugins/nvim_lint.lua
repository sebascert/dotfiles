
vim.g.LINTING = true

local function ToggleLinting(enable)
    vim.g.LINTING = enable
    if enable then
        Lint()
    else
        vim.diagnostic.reset()
    end
end

function Lint()
    vim.print("lint attempt")
    if not LINTING then
        return
    end

    -- Use nvim-lint's logic first:
    -- * checks if linters exist for the full filetype first
    -- * otherwise will split filetype by "." and add all those linters
    -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    local lint = require("lint")
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)

    -- Create a copy of the names table to avoid modifying the original.
    names = vim.list_extend({}, names)

    -- Add fallback linters.
    if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end

    -- Add global linters.
    vim.list_extend(names, lint.linters_by_ft["*"] or {})

    -- Filter out linters that don't exist or don't match the condition.
    local ctx = { filename = vim.api.nvim_buf_get_name(0) }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
    names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
    end, names)

    -- Run linters.
    if #names > 0 then
        lint.try_lint(names)
    end
end

local function config(_, opts)
    local lint = require("lint")
    local time=require("utils.time")

    lint.linters_by_ft = opts.linters_by_ft

    -- load linter configs
    if opts.linters then
        for name, conf in pairs(opts.linters) do
            local linter = lint.linters[name]
            for key, value in pairs(conf) do
                linter[key] = value
            end
        end
    end

    -- create au on configured events
    vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
            time.debounce(100, Lint)()
        end,
    })

    -- command interface
    local cmd = vim.api.nvim_create_user_command
    cmd("Lint", Lint, {});
    cmd("LintEnable", function() ToggleLinting(true) end, {})
    cmd("LintDisable", function() ToggleLinting(false) end, {})
    cmd("Linters", function()
        vim.print(table.concat(lint.get_running(),", "))
    end, {})
end

return {
    "mfussenegger/nvim-lint",
    opts = {
        events = { "BufReadPost", "BufWritePost", "TextChanged", "TextChangedI" },
        linters_by_ft = {
            lua = { "stylua" },

            python = { "mypy" },

            sh = { "shellcheck" },
            bash = { "shellcheck" },

            c = { "clangtidy" },
            cpp = { "clangtidy" },

            make = { "checkmake" },

            tex = { "vale" },

            ["*"] = { "codespell" },
        },
        linters ={
            shellcheck = {
                args = {
                    "--format",
                    "json",
                    "--shell",
                    "bash",
                    "-",
                }
            }
        }
    },
    config = config,
}
