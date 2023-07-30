return {
    'numToStr/FTerm.nvim',
    keys = {
        { "<leader>s", '<CMD>lua require("FTerm").toggle()<CR>', desc = "FTerm" },
    },
    opts = {
        border = 'single',
        blend = 0,
    }
}
