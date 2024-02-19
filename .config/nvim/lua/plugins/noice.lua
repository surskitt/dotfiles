return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            cmdline = {
                enabled = true,
                view = "cmdline",
            },
            -- messages = {
            --     enabled = false,
            -- },
            views = {
                mini = {
                    timeout = 5000,
                    win_options = {
                        winblend = 0,
                        winhighlight = {
                            NoiceLspProgressTitle = "Normal",
                        },
                    },
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
        },
    },
}
