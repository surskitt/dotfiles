vim.api.nvim_create_autocmd({ "QuitPre" }, {
    pattern = { "*" },
    command = "qa",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
    callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
    end,
    pattern = { "terraform", "hcl" },
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        vim.opt.colorcolumn = "72"
    end,
    pattern = { "gitcommit" },
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        vim.opt.colorcolumn = "100"
    end,
    pattern = { "markdown" },
})
