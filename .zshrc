 source ~/.profile
 source ~/.aliases
 source ~/.functions

source ~/.zshrc.d/profile.zshrc
source ~/.zshrc.d/autoload.zshrc
source ~/.zshrc.d/zle.zshrc
source ~/.zshrc.d/plugins.zshrc
source ~/.zshrc.d/opts.zshrc
source ~/.zshrc.d/zstyle.zshrc
source ~/.zshrc.d/zmodload.zshrc

source ~/.zshrc.d/bindings.zshrc

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

autoload -U +X bashcompinit && bashcompinit

eval "$(starship init zsh)"
export RPROMPT=""
