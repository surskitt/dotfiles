return {
    'akinsho/bufferline.nvim',
    event = "VeryLazy",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup({
            options = {
                style_preset = bufferline.style_preset.no_italic,
                always_show_bufferline = true,
                separator_style = {'', ''},
            }
        })
    end,
}
