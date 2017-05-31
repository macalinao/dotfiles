#!/usr/bin/env bash

DOTFILES=$HOME/dotfiles

for FILE in $(ls $DOTFILES/dotfiles); do
    BASE=`basename $FILE`
    SOURCE=$DOTFILES/dotfiles/$BASE
    TARGET=$HOME/.$BASE
    echo "Creating symlink for $SOURCE at $TARGET"
    if [ -L $TARGET ]; then
        unlink $TARGET
    fi
    ln -s $SOURCE $TARGET
done

SOURCE="source $DOTFILES/lib/bashrc"
if ! grep -Fxq "$SOURCE" $HOME/.bashrc; then
    echo "$SOURCE" >> $HOME/.bashrc
fi

SOURCE="source $DOTFILES/lib/zshrc"
if ! grep -Fxq "$SOURCE" $HOME/.zshrc; then
    echo "$SOURCE" >> $HOME/.zshrc
fi
