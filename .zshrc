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

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

compdef _files bat
compdef _files sops
compdef _files dragon-drag-and-drop

compdef g=git
compdef v=nvim
compdef y=yadm
compdef yw=yadm

eval "$(starship init zsh)"
export RPROMPT=""
