#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

dir=~/dotfiles                    # dotfiles directory
files="config fonts gitignore_global gradle themes vim vimrc oh-my-zsh zshrc"    # list of files/folders to symlink in homedir

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

echo "Installing fonts..."
fc-cache -fv ~/.fonts

echo "Setting global gitignore..."
git config --global core.excludesFile ~/.gitignore_global
