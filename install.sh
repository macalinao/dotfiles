#!/usr/bin/env bash

DIR=$(dirname $0)

cd $DIR
FILES="atom gitconfig jsbeautifyrc spacemacs vim vimrc"

for FILE in $FILES; do
  echo "Creating symlink for $dir/$FILE at $HOME/.$FILE."
  if [ -L $HOME/.$FILE ]; then
    unlink $HOME/.$FILE
  fi
  ln -s $DIR/$FILE $HOME/.$FILE
done

echo "source ~/dotfiles/zshrc" >> ~/.zshrc
echo "source ~/dotfiles/tmux.conf" >> ~/.tmux.conf
