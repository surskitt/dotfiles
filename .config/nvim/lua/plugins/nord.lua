return {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.nord_disable_background = true
        vim.g.nord_italic = false
        vim.g.nord_bold = false
        vim.g.nord_borders = true

        local grpid = vim.api.nvim_create_augroup('custom_highlights_nord', {})
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = grpid,
            pattern = 'nord',
            callback = function()
                vim.cmd [[highlight FloatBorder guibg=NONE ctermbg=NONE]]
                vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#4c566a" })
            end
        })

        vim.cmd([[colorscheme nord]])
        -- require('nord').set()
        -- vim.cmd([[highlight VertSplit guibg=NONE ctermbg=NONE]])
    end
}
