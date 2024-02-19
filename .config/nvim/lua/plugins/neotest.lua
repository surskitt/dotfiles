return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/neotest-go",
        "nvim-neotest/neotest-python",
        "rouge8/neotest-rust",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-go"),
                require("neotest-python"),
                require("neotest-rust"),
            },
            status = { virtual_text = true },
            output = { open_on_run = true },
        })
    end,
    keys = {
        { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run file" },
        { "<leader>tw", function() require("neotest").watch.watch(vim.fn.expand("%")) end,                  desc = "Watch file" },
        { "<leader>ta", function() require("neotest").run.run(vim.loop.cwd()) end,                          desc = "Run all test files" },
        { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run nearest" },
        { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run last" },
        { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle summary" },
        { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
        { "<leader>tp", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle output panel" },
        { "<leader>tx", function() require("neotest").run.stop() end,                                       desc = "Stop" },
    },
}
