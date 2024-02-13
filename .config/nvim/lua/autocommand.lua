vim.api.nvim_create_autocmd({ "QuitPre" }, {
    pattern = { "*" },
    command = "qa",
})
