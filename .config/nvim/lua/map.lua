-- move between buffers
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { desc = "next buffer" })
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "previous buffer" })

-- close buffer
vim.keymap.set("n", "<leader>dd", ":bd<CR>", { desc = "close buffer" })

-- clear search
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { desc = "clear search" })

-- move lines selected in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in same place when using J
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in the middle when moving by half page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor in the middle when moving through searches
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "yank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "yank to system clipboard" })

-- remove Q
vim.keymap.set("n", "Q", "<nop>")

-- chmod +x current file
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "chmod +x", silent = true })

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "switch to last file" })

vim.keymap.set("n", "U", "<C-r>", { desc = "redo" })

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "lsp rename" })

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "go to definition" })
