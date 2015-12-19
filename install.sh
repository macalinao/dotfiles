#!/usr/bin/env bash

dir=$(dirname $0)
files="config fonts gitignore_global themes tmux.conf up-config vim vimrc oh-my-zsh zshrc"

echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Creating symlink for $dir/$file at $HOME/.$file."
    if [ -L $HOME/.$file ]
    then
        unlink $HOME/.$file
    fi
    ln -s $dir/$file $HOME/.$file
done

echo "Setting global gitignore..."
git config --global core.excludesFile ~/.gitignore_global
