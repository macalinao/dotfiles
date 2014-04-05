#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

dir=~/dotfiles
files="config fonts gitignore_global gradle powerline themes tmux.conf up-config vim vimrc oh-my-zsh zshrc"

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

echo "Installing fonts..."
fc-cache -fv ~/.fonts

echo "Setting global gitignore..."
git config --global core.excludesFile ~/.gitignore_global
