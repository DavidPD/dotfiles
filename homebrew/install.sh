#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install homebrew packages
# brew install grc coreutils spark
brew install zsh git hub z fzf bat

# install cask applications
brew cask install hammerspoon sublime-text

brew tap homebrew/cask-fonts
brew cask install font-fira-code

exit 0
