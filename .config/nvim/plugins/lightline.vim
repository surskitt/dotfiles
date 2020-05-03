let g:lightline = {}
let g:lightline.colorscheme = 'wal'
let g:lightline.active = {
\   'left': [['mode', 'paste'],
\            ['gitbranch', 'readonly', 'filename', 'modified']],
\   'right': [['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'], ['row_column', 'percent']],
\}
let g:lightline.tabline = {
\   'left': [['bufferbefore', 'buffercurrent', 'bufferafter'],],
\   'right': [[],],
\}
let g:lightline.component_expand = {
\   'buffercurrent': 'lightline#buffer#buffercurrent',
\   'bufferbefore': 'lightline#buffer#bufferbefore',
\   'bufferafter': 'lightline#buffer#bufferafter',
\   'linter_checking': 'lightline#ale#checking',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok',
\}
let g:lightline.component_type = {
\   'buffercurrent': 'tabsel',
\   'bufferbefore': 'raw',
\   'bufferafter': 'raw',
\   'linter_checking': 'left',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'linter_ok': 'left',
\}
let g:lightline.component_function = {'bufferinfo': 'lightline#buffer#bufferinfo',}
let g:lightline.component = {
\   'separator': '',
\   'row_column': '%3l:%-2c',
\}
let g:lightline.separator = {
\   'left': '',
\   'right': ''
\}
let g:lightline.subseparator = {
\   'left': '',
\   'right': ''
\}
let g:lightline#ale#indicator_checking = ""
let g:lightline#ale#indicator_warnings = ""
let g:lightline#ale#indicator_errors = ""
let g:lightline#ale#indicator_ok = ""
