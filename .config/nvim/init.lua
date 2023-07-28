require("set")
require("map")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup('plugins', {
    install = {
        colorscheme = {"nord"},
    },
    change_detection = {
        notify = false,
    }
})

-- don't enter comments on new lines following comments on preceding lines
vim.cmd [[ autocmd FileType * set formatoptions-=cro ]] 
