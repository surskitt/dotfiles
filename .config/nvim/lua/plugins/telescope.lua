local select_one_or_multi = function(prompt_bufnr)
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        for _, j in pairs(multi) do
            if j.path ~= nil then
                vim.cmd(string.format('%s %s', 'edit', j.path))
            end
        end
    else
        require('telescope.actions').select_default(prompt_bufnr)
    end
end

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        cmd = "Telescope",
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "debugloop/telescope-undo.nvim",
            "benfowler/telescope-luasnip.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top" -- search bar at the top
                    },
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-u>"] = false,
                            ["<CR>"]  = select_one_or_multi,
                        },
                        n = {
                            ["<CR>"] = select_one_or_multi,
                            ["<Space>"] = actions.toggle_selection + actions.move_selection_next,
                        },
                    }
                },
                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                ['<C-d>'] = actions.delete_buffer,
                            },
                            n = {
                                ['dd'] = actions.delete_buffer,
                            },
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }

            })

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("undo")
            require('telescope').load_extension('luasnip')
            require("telescope").load_extension('yaml_schema')
            require("telescope").load_extension("ui-select")
        end,
        keys = {
            { "<leader>ff", function() require('telescope.builtin').find_files() end,                 desc = "Find files" },
            { "<leader>fb", function() require('telescope.builtin').buffers() end,                    desc = "Find buffers" },
            { "<leader>fg", function() require('telescope.builtin').live_grep() end,                  desc = "Grep files" },
            { "<leader>ft", function() require('telescope.builtin').filetypes() end,                  desc = "Pick filetypes" },
            { "<leader>fl", function() require('telescope.builtin').current_buffer_fuzzy_find() end,  desc = "Search current buffer" },
            { "<leader>fn", function() require('telescope.builtin').treesitter() end,                 desc = "Search treesitter" },
            { "<leader>fu", function() require('telescope').extensions.undo.undo() end,               desc = "Search undotree" },
            { "<leader>fs", function() require('telescope').extensions.luasnip.luasnip() end,         desc = "Search snippets" },
            { "<leader>fa", function() require('telescope.builtin').builtin() end,                    desc = "Telescope" },
            { "<leader>fy", function() require('telescope').extensions.yaml_schema.yaml_schema() end, desc = "Telescope" },
            { "<leader>fc", function() vim.lsp.buf.code_action() end,                                 desc = "Code actions" },
            { "<leader>fh", function() require('telescope.builtin').help_tags() end,                  desc = "Search help" },
            { "<leader>fd", function() require('telescope.builtin').diagnostics() end,                desc = "Search diagnostics" },
        }
    },
}
