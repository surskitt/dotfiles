return {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = { "BufReadPre " .. vim.fn.expand "~" .. "/obsidian/**.md" },
    keys = {
        { "<leader>fo", "<cmd>ObsidianQuickSwitch<CR>", desc = "Open an obsidian note" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",

        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
    },
    opts = {
        dir = "~/obsidian", -- no need to call 'vim.fn.expand' here
        mappings = {},
    },
}
