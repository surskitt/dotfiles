set-option -g @tpm_plugins ''

set-option -g -a @tpm_plugins 'tmux-plugins/tpm '

set-option -g -a @tpm_plugins 'tmux-plugins/tmux-copycat '

if-shell 'test -n "$DISPLAY"' {
    set-option -g -a @tpm_plugins 'tmux-plugins/tmux-yank '
    set-option -g -a @tpm_plugins 'brennanfee/tmux-paste '
    set-option -g -a @tpm_plugins 'wfxr/tmux-fzf-url '
}

run -b '~/.tmux/plugins/tpm/tpm'
