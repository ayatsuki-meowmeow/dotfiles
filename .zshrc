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
export PATH="/Users/konoreiji/.bun/bin:$PATH"

source <(fzf --zsh)
source ~/.fzf-git.sh

bf() { local f; f=$(ls | fzf) && bat -- "$f"; }
vf() { local f; f=$(ls | fzf) && nvim -- "$f"; }
cf() { local d; d=$(ls -d */ | fzf) && cd -- "$d"; }

eval "$(zoxide init zsh)"

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

if [ -f ~/.aliases ]; then
  source ~/.aliases
fi
