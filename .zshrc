eval "$(starship init zsh)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/konoreiji/.dart-cli-completion/zsh-config.zsh ]] && . /Users/konoreiji/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

eval "(rbenv init -)"
alias flutter="fvm flutter"
