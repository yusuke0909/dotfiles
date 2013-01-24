#!/bin/bash

DOT_FILES=( .zshrc .zshrc.alias .zshrc.linux .zshrc.osx .gitconfig .gitignore .vimrc .tmux.conf .dircolors )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done
