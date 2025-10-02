eval "$(starship init zsh)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/konoreiji/.dart-cli-completion/zsh-config.zsh ]] && . /Users/konoreiji/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

eval "(rbenv init -)"
alias flutter="fvm flutter"
alias pm="pnpm"
alias px="pnpm dlx"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
