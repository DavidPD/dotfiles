#! /usr/bin/env zsh
set -e

INSTALL_DIR=${0%/*}

if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install swift-sh

./$INSTALL_DIR/CopyFiles.swift
