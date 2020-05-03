let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_linters = {
\   'haskell': ['ghc'] ,
\   'python': ['pycodestyle'],
\   'go': ['gopls', 'golangci-lint']
\}
let g:ale_fixers = {'python': ['yapf'],}
