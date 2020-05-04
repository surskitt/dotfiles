let g:go_fmt_command = "goimports"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

autocmd FileType go map <leader>xt <Plug>(go-test)
autocmd FileType go map <leader>xc <Plug>(go-coverage-toggle)
autocmd FileType go map <leader>xi <Plug>(go-imports)
autocmd FileType go map <leader>xa <Plug>(go-alternate)
autocmd FileType go map <leader>xr <Plug>(go-run)
autocmd FileType go map <leader>xb <Plug>(go-build)
