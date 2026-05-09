-- inspired from https://www.lazyvim.org/plugins/treesitter

local function config(_, opts)
    local TS = require("nvim-treesitter")

    TS.setup(opts)

    TS.install(opts.parsers)

    local augroup =
        vim.api.nvim_create_augroup("nvim-treesitter-config", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        group = augroup,
        callback = function(args)
            local bufnr = args.buf
            local ft = vim.bo[bufnr].filetype
            local lang = vim.treesitter.language.get_lang(ft) or ft

            -- only start if a parser exists/loads successfully
            local ok = pcall(vim.treesitter.get_parser, bufnr, lang)
            if not ok then
                return
            end

            -- syntax highlight
            vim.treesitter.start()

            -- folds
            -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.wo[0][0].foldmethod = "expr"

            -- indentation
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })
end

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = config,

    opts = {
        -- default
        install_dir = vim.fn.stdpath("data") .. "/site",
        parsers = {
            "asm",
            "bash",
            "bitbake",
            "c",
            "c_sharp",
            "cmake",
            "cpp",
            "css",
            "cuda",
            "diff",
            "disassembly",
            "dockerfile",
            "gdscript",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "graphql",
            "haskell",
            "html",
            "ini",
            "java",
            "javascript",
            "json",
            "latex",
            "llvm",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "matlab",
            "mermaid",
            "nginx",
            "objdump",
            "perl",
            "php",
            "powershell",
            "python",
            "regex",
            "rust",
            "scheme",
            "sql",
            "ssh_config",
            "strace",
            "tmux",
            "toml",
            "typescript",
            "vim",
            "vim",
            "xml",
            "yaml",
            "zathurarc",
            "zig",
        },
    },
}
