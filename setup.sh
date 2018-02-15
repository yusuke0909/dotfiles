#!/bin/bash

DOT_FILES=( .zshrc .zshenv .zshrc.alias .zshrc.linux .zshrc.osx .gitconfig .gitignore .vimrc .tmux.conf .sshrc .sshrc.d .dircolors bin )

for file in ${DOT_FILES[@]}
do
    ln -s $file $HOME/$file
done
