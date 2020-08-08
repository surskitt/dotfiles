bindkey -M vicmd 'v' edit-command-line
bindkey '^ ' autosuggest-accept
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -r 'h'
bindkey -M vicmd -r ' '
bindkey -M vicmd -r ':'

# remap fzf cd from alt+c to alt+d
bindkey -r '\ec'
bindkey '\ef' fzf-cd-widget
