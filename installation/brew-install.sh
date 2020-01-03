#! /usr/bin/env zsh
#
# This script installs various dependencies via homebrew
# At some point I'd like to make this a little fancier using swift.

# Install brew if needed
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Let's use a not-so-out-of-date version of zsh and git
brew install zsh
brew install git

# Antibody is a zsh plugin manager
brew install getantibody/tap/antibody

# Used for swift scripting and automatic dependency fetching
brew install swift-sh

# Fly around the filesystem like a madman (frecency based terminal navigation)
brew install z

# Fuzzy search program that offers previews, navigation, and other cool stuff
brew install fzf

# Bat is cat but better. offers paging, syntax highlighting, line numbers, etc.
brew install bat

# Install text editors
brew cask install sublime-text visual-studio-code

# Sublime merge is a fairly minimal git GUI that handles diffs nicely
brew cask install sublime-merge

# Install my preferred coding font
brew tap homebrew/cask-fonts
brew cask install font-fira-code
