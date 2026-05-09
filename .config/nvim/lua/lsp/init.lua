local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
    end,
})

-- LUA
vim.lsp.enable("lua_ls")

-- C/CPP
vim.lsp.enable("clangd")

-- RUST
vim.lsp.enable("rust_analyzer")

-- PYTHON
vim.lsp.enable("pyright")

-- JAVASCRIPT
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")

-- JAVA
vim.lsp.enable("jdtls")

-- C#
-- vim.lsp.enable("roslyn")

-- BASH
vim.lsp.enable("bashls")

-- LATEX
vim.lsp.enable("texlab")

-- MARKDOWN
vim.lsp.enable("marksman")
