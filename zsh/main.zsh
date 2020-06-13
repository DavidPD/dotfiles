export ZSH=$HOME/.oh-my-zsh
export DOTFILES=$HOME/.dotfiles
export ZSH_CUSTOM=$DOTFILES/zsh/oh-my-zsh
export ZSH_THEME='remy'
source $ZSH/oh-my-zsh.sh

path+=("$HOME/.dotfiles/bin")

source <(antibody init)
antibody bundle < $DOTFILES/zsh/zsh-plugins.txt

# TODO: Dynamically source zsh files?
source $DOTFILES/zsh/aliases.zsh

# initialize z
source `brew --prefix`/etc/profile.d/z.sh
