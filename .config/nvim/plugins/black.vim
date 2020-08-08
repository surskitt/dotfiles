autocmd FileType python autocmd BufWritePre *.py execute ':Black'

let g:black_linelength = 79
