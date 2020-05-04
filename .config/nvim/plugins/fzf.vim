command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd -t file'}), <bang>0)

map <leader>f :Files<CR>
map <leader>b :Buffers<CR>
