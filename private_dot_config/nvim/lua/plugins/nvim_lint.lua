vim.g.LINTING = true

local function get_running()
    -- inspired from https://www.lazyvim.org/plugins/linting#nvim-lint
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
        return linter
            and not (
                type(linter) == "table"
                and linter.condition
                and not linter.condition(ctx)
            )
    end, names)

    return names
end

local function try_lint()
    if not vim.g.LINTING then
        return
    end

    local lint = require("lint")

    local names = get_running()
    if #names > 0 then
        lint.try_lint(names)
    end
end

local function configure_linters(opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft

    for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
            lint.linters[name] =
                vim.tbl_deep_extend("force", lint.linters[name], linter)
            if type(linter.prepend_args) == "table" then
                lint.linters[name].args = lint.linters[name].args or {}
                vim.list_extend(lint.linters[name].args, linter.prepend_args)
            end
        else
            lint.linters[name] = linter
        end
    end
end

local function config(_, opts)
    local time = require("utils.time")

    configure_linters(opts)

    local debounced_lint = time.debounce(100, try_lint)

    local function toggle_linting(state)
        return function()
            vim.g.LINTING = state
            if not state then
                vim.diagnostic.reset()
            end
        end
    end

    -- create au on configured events
    local augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
    vim.api.nvim_create_autocmd(opts.events, {
        group = augroup,
        callback = debounced_lint,
    })

    -- command interface
    local cmd = vim.api.nvim_create_user_command
    cmd("Lint", debounced_lint, {})
    cmd("LintEnable", toggle_linting(true), {})
    cmd("LintDisable", toggle_linting(false), {})
    cmd("Linters", function()
        vim.print(get_running())
    end, {})
end

return {
    "mfussenegger/nvim-lint",
    opts = {
        events = {
            "BufReadPost",
            "BufWritePost",
            "TextChanged",
            "TextChangedI",
        },
        linters_by_ft = {
            lua = { "selene" },

            c = { "clangtidy" },
            cpp = { "clangtidy" },

            python = { "mypy", "ruff" },

            sh = { "shellcheck" },
            bash = { "shellcheck" },

            make = { "checkmake" },

            tex = { "vale" },
            markdown = { "vale" },

            ["*"] = { "codespell" },
        },
        linters = {
            shellcheck = {
                prepend_args = { "--shell", "bash" },
            },
        },
    },
    config = config,
}
