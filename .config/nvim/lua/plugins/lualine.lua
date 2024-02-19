-- get schema for current buffer
local function get_schema()
    local schema = require("yaml-companion").get_buf_schema(0)
    if schema.result[1].name == "none" then
        return ""
    end
    return schema.result[1].name
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "meuter/lualine-so-fancy.nvim",
    },
    opts = {
        options = {
            theme = "nord",
            section_separators = '',
            component_separators = '',
        },
        sections = {
            lualine_a = {
                { 'fancy_mode', icon = '', width = 7 },
                { 'fancy_macro', icon = '' },
            },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'filename', path = 3, icon = '' }, },
            lualine_x = { 'fancy_filetype', 'fancy_lsp_servers', get_schema },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
    }
}
