
call plug#begin(stdpath('data') . '/plugged')

" A vim colorscheme for use with wal
Plug 'sharktamer/wal.vim'

" A full set of 1-, 8-, 16-, 88-, 256-, and GUI-color-compatible Vim colors.
Plug 'jsit/disco.vim'

" A solid language pack for Vim.
Plug 'sheerun/vim-polyglot'

" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'

" A buffer plugin for lightline.vim
Plug 'taohexxx/lightline-buffer'

" Adds file type glyphs/icons to popular Vim plugins
Plug 'ryanoasis/vim-devicons'

" ALE indicator for the lightline vim plugin
Plug 'maximbaz/lightline-ale'

" Provides insert mode auto-completion for quotes, parens, brackets
Plug 'Raimondi/delimitMate'

" Vim plugin for intensely orgasmic commenting
Plug 'scrooloose/nerdcommenter'

" Preview css colours in source code while editing
Plug 'ap/vim-css-color'

" Markdown Vim Mode
Plug 'plasticboy/vim-markdown'

" A vim plugin for syntax highlighting Ansible's common filetypes
Plug 'pearofducks/ansible-vim'

" Asynchronous Lint Engine
Plug 'w0rp/ale'

" Show a diff using Vim its sign column.
Plug 'mhinz/vim-signify'

" The ultimate undo history visualizer for VIM
Plug 'mbbill/undotree'

" True Sublime Text style multiple selections for Vim
Plug 'terryma/vim-multiple-cursors'

" A vim plugin to give you some slime. (Emacs)
Plug 'jpalardy/vim-slime'

" fzf <3 vim
Plug 'junegunn/fzf.vim'

" Make terminal vim and tmux work better together.
Plug 'tmux-plugins/vim-tmux-focus-events'

" Handles bracketed-paste-mode in vim (aka. automatic `:set paste`)
Plug 'ConradIrwin/vim-bracketed-paste'

" Distraction free writing in vim
Plug 'junegunn/goyo.vim'

" Go development plugin for Vim
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" vim-easyescape makes exiting insert mode easy and distraction free!
Plug 'zhou13/vim-easyescape'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'airblade/vim-rooter'

Plug 'liuchengxu/vim-which-key'

call plug#end()
