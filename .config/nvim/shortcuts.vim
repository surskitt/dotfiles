cnoremap jj <ESC>
imap jj <ESC>

map <leader>r :source ~/.config/nvim/init.vim<CR>

map <leader>t :enew<CR>
map <leader>l :bnext<CR>
map <leader>h :bprevious<CR>
map <leader>d :bd<CR>
map <leader>/ :nohlsearch<CR>
map <leader>g :Goyo<CR>
map <leader>s :w<CR>
map <leader>qq :q<CR>

map <leader>qc :cclose<CR>
map <leader>qo :copen<CR>
map <leader>qn :cnext<CR>
map <leader>qp :cprevious<CR>

map <leader>wc :lclose<CR>
map <leader>wo :lopen<CR>
map <leader>wn :lnext<CR>
map <leader>wp :lprevious<CR>

command! W write
command! Q quit
