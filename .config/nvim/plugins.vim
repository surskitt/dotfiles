
call plug#begin(stdpath('data') . '/plugged')

Plug 'sharktamer/wal.vim' " A vim colorscheme for use with wal
Plug 'jsit/disco.vim' " A full set of 1-, 8-, 16-, 88-, 256-, and GUI-color-compatible Vim colors.
Plug 'sheerun/vim-polyglot' " A solid language pack for Vim.
Plug 'itchyny/lightline.vim' " A light and configurable statusline/tabline plugin for Vim
Plug 'taohexxx/lightline-buffer' " A buffer plugin for lightline.vim
Plug 'ryanoasis/vim-devicons' " Adds file type glyphs/icons to popular Vim plugins
Plug 'maximbaz/lightline-ale' " ALE indicator for the lightline vim plugin
Plug 'scrooloose/nerdcommenter' " Vim plugin for intensely orgasmic commenting
Plug 'plasticboy/vim-markdown' " Markdown Vim Mode
Plug 'pearofducks/ansible-vim' " A vim plugin for syntax highlighting Ansible's common filetypes
Plug 'w0rp/ale' " Asynchronous Lint Engine
Plug 'mhinz/vim-signify' " Show a diff using Vim its sign column.
Plug 'terryma/vim-multiple-cursors' " True Sublime Text style multiple selections for Vim
Plug 'junegunn/fzf.vim' " fzf <3 vim
Plug 'tmux-plugins/vim-tmux-focus-events' " Make terminal vim and tmux work better together.
Plug 'ConradIrwin/vim-bracketed-paste' " Handles bracketed-paste-mode in vim (aka. automatic `:set paste`)
Plug 'junegunn/goyo.vim' " Distraction free writing in vim
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go development plugin for Vim
Plug 'zhou13/vim-easyescape' " vim-easyescape makes exiting insert mode easy and distraction free!
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " Intellisense engine for Vim8 & Neovim, full language server protocol support as VSCode
Plug 'liuchengxu/vim-which-key' " Vim plugin that shows keybindings in popup
Plug 'psf/black', { 'branch': 'stable' } " The uncompromising Python code formatter
Plug 'zhimsel/vim-stay' " Make Vim persist editing state without fuss

call plug#end()
