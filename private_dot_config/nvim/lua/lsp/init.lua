local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
    capabilities = capabilities,
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
