return {
    "zapling/mason-lock.nvim",
    opts = {
        lockfile_path = vim.fn.stdpath("config") .. "/mason-lock.json",
    },
    build = ":MasonLockRestore",
}
