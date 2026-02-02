vim.keymap.set({ "n", "x" }, "<F2>", function()
    require("conform").format({ async = true })
end)

return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            rust = { "rustfmt" },

            lua = { "stylua" },

            sh = { "beautysh" },
            bash = { "beautysh" },

            toml = { "tombi" },

            scheme = { "dprint" },
            markdown = { "dprint" },

            tex = { "tex-fmt" },

            ["*"] = { "trim_whitespace" },
        },
        formatters = {
            injected = { options = { ignore_errors = true } },

            dprint = {
                -- use dprint only when a dprint.json file is present
                condition = function(ctx)
                    return vim.fs.find(
                        { "dprint.json" },
                        { path = ctx.filename, upward = true }
                    )[1]
                end,
            },
        },
        format_after_save = {
            lsp_format = "fallback",
        },
    },
}
