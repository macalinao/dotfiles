#!/usr/bin/env bash

pushd `dirname $0` > /dev/null
DIR=`pwd`
popd > /dev/null

cd $DIR
FILES="fonts gitignore_global tmux.conf vim vimrc"

for FILE in $FILES; do
  echo "Creating symlink for $dir/$FILE at $HOME/.$FILE."
  if [ -L $HOME/.$FILE ]; then
    unlink $HOME/.$FILE
  fi
  ln -s $DIR/$FILE $HOME/.$FILE
done

echo "source ~/dotfiles/zshrc" >> ~/.zshrc

echo "Setting global Git settings..."
git config --global user.name "Ian Macalinao"
git config --global user.email "me@ian.pw"
git config --global core.excludesFile ~/.gitignore_global
