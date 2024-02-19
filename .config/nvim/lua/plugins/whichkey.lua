return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300

        local wk = require("which-key")

        wk.register({
            ["<leader>"] = {
                d = { name = "+delete" },
                f = { name = "+file" },
                t = { name = "+test" },
                x = { name = "+trouble" },
                g = { name = "+go to" },
            }
        })
    end,
}
