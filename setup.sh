#!/bin/bash

DIR=$(pwd)
DOT_FILES=( .zshrc .zshenv .zshrc.alias .zshrc.linux .zshrc.osx .gitconfig .gitignore .vimrc .tmux.conf .peco .sshrc .sshrc.d .dircolors bin )

for file in ${DOT_FILES[@]}
do
    ln -s ${DIR}/${file} $HOME/${file}
done

# copy .config/* to home directory
cp -r ${DIR}/.config $HOME/.config
