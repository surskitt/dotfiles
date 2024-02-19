return {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
        { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",                                   desc = "Document Diagnostics (Trouble)" },
        { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",                                  desc = "Workspace Diagnostics (Trouble)" },
        { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",                                                desc = "Location List (Trouble)" },
        { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",                                               desc = "Quickfix List (Trouble)" },
        { "<leader>xn", function() require("trouble").next({ skip_groups = true, jump = true }) end,     desc = "Quickfix List (Trouble)" },
        { "<leader>xp", function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "Quickfix List (Trouble)" },
    },
}
