#! /usr/bin/env zsh
set -e

INSTALL_DIR=${0%/*}

# Install brew dependencies
./$INSTALL_DIR/brew-install.sh

./$INSTALL_DIR/CopyFiles.swift
