return {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.nord_disable_background = true
        vim.g.nord_italic = false
        vim.g.nord_bold = false
        vim.g.nord_borders = true

        grpid = vim.api.nvim_create_augroup('custom_highlights_nord', {})
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = grpid,
            pattern = 'nord',
            command = 'highlight FloatBorder guibg=NONE ctermbg=NONE',
        })

        vim.cmd([[colorscheme nord]])
        -- require('nord').set()
        -- vim.cmd([[highlight VertSplit guibg=NONE ctermbg=NONE]])
    end
}
