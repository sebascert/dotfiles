local rg_find_patterns = {
    { "-g", "!.git" },
    { "-g", "!*venv" },
    { "-g", "!__pycache__" },
    { "-g", "!node_modules" },
    { "-g", "!.mypy_cache" },
}

local function find_files_cmd()
    local cmd = {
        "rg",
        "--files",
        "--color",
        "never",
        "--hidden",
        "--no-ignore-vcs",
    }

    for _, pattern in ipairs(rg_find_patterns) do
        for _, arg in ipairs(pattern) do
            table.insert(cmd, arg)
        end
    end

    return cmd
end

local function live_grep_cmd()
    -- These are Telescope's defaults, but explicitly rg-based and with your globs added.
    local args = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--no-ignore-vcs",
    }

    for _, pattern in ipairs(rg_find_patterns) do
        for _, arg in ipairs(pattern) do
            table.insert(args, arg)
        end
    end

    return args
end

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        defaults = {
            vimgrep_arguments = live_grep_cmd(),
        },
        pickers = {
            find_files = {},
        },
    },

    config = function(_, opts)
        if vim.fn.executable("rg") ~= 1 then
            error("ripgrep not found")
        else
            opts.pickers.find_files.find_command = find_files_cmd()
        end

        require("telescope").setup(opts)

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    end,
}
