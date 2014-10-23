#!/bin/sh

if [[ ! -f ~/.vim/autoload/pathogen.vim ]] ; then
	mkdir -p ~/.vim/autoload ~/.vim/bundle && \
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

if [[ ! -d ~/.vim/bundle/vim-colors-solarized ]] ; then
	git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
fi
