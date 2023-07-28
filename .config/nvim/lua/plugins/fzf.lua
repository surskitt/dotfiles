return {
    "ibhagwan/fzf-lua",
    lazy = true,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        fzf_opts = {
            ['--layout'] = 'reverse-list'
        }
    },
    keys = {
        { "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", silent = true}
    }
}
