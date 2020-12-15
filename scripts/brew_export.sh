#!/usr/bin/env bash

brew list --formula > $HOME/dotfiles/etc/brew.txt
brew list --cask --formula > $HOME/dotfiles/etc/brew-cask.txt

