return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "debugloop/telescope-undo.nvim",
            "benfowler/telescope-luasnip.nvim",
        },
        config = function()
            telescope = require("telescope")
            actions = require("telescope.actions")

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
            })

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("undo")
            require('telescope').load_extension('luasnip')
        end,
        keys = {
            { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>",                desc = "Find files" },
            { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>",                   desc = "Find buffers" },
            { "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>",                 desc = "Grep files" },
            { "<leader>ft", "<cmd>lua require('telescope.builtin').filetypes()<cr>",                 desc = "Pick filetypes" },
            { "<leader>fl", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", desc = "Search current buffer" },
            { "<leader>fn", "<cmd>lua require('telescope.builtin').treesitter()<cr>",                desc = "Search current buffer" },
            { "<leader>fu", "<cmd>lua require('telescope').extensions.undo.undo()<cr>",              desc = "Search current buffer" },
            { "<leader>fs", "<cmd>lua require('telescope').extensions.luasnip.luasnip()<cr>",        desc = "Search current buffer" },
        }
    },
}
