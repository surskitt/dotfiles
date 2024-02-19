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
                        }
                    }
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
