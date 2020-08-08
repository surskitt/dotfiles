if ! zgen saved; then
    zgen load shanedabes/shagnoster shagnoster.zsh-theme
    zgen load sharat87/zsh-vim-mode
    zgen load zsh-users/zsh-autosuggestions
    zgen load zuxfoucault/colored-man-pages_mod
    zgen load zsh-users/zsh-history-substring-search
    zgen load zdharma/fast-syntax-highlighting
    # zgen load hlissner/zsh-autopair
    zgen load ninrod/pass-zsh-completion

    zgen save
    zcompile "${HOME}/.zgen/init.zsh"
else
    source "${HOME}/.zgen/init.zsh"
fi
