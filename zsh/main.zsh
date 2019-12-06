export ZSH=$HOME/.oh-my-zsh
export DOTFILES=$HOME/.dotfiles
export ZSH_CUSTOM=$DOTFILES/zsh/oh-my-zsh

export ZSH_THEME='remy'

source $ZSH/oh-my-zsh.sh

# TODO: Dynamically source zsh files?
source $DOTFILES/zsh/aliases.zsh
