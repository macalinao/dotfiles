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

APPENDS=(tmux.conf zshrc)

for APPEND in APPENDS; do
    SOURCE="source $DOTFILES/dotfiles/$APPEND"
    if ! grep -Fxq "$SOURCE" $HOME/.$APPEND; then
        echo "$SOURCE" >> $HOME/.$APPEND
    fi
done
