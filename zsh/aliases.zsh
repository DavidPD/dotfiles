alias reload!='. ~/.zshrc'

alias genocide='killall'
alias fzf-bat="fzf --preview 'bat --style=full --color=always {}' "
alias f="fzf-bat --height=40% --min-height=20"
alias fe='e $(f)'

# setup gnu utils, if available
if [[ -d /usr/local/opt/coreutils/libexec/gnubin ]] ; then
	export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
	unalias ls
	alias ls="ls --color"
	eval `dircolors $DOTFILES/zsh/dir_colors`
fi

# clear the terminal screen & delete scrollback
alias clear="\clear;printf '\e[3J' && printf '\e]50;ClearScrollback\a'"

function ze () {
	$(z $1 && e)
}