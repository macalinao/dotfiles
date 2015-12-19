#!/usr/bin/env bash

cd $(dirname $0)/../
files="fonts gitignore_global tmux.conf vim vimrc oh-my-zsh zshrc"

for file in $files; do
    echo "Creating symlink for $dir/$file at $HOME/.$file."
    if [ -L $HOME/.$file ]; then
        unlink $HOME/.$file
    fi
    ln -s $dir/$file $HOME/.$file
done

echo "Setting global Git settings..."
git config --global user.name "Ian Macalinao"
git config --global user.email "me@ian.pw"
git config --global core.excludesFile ~/.gitignore_global
