#!/bin/bash

DIR=$(pwd)
DOT_FILES=( .zshrc .zshenv .zshrc.alias .zshrc.linux .zshrc.osx .gitconfig .gitignore .tigrc .vimrc .tmux.conf .peco .sshrc .sshrc.d .dircolors bin )
DOT_CONFIG_DIR=( karabiner powerline-shell )

for file in ${DOT_FILES[@]}
do
    ln -s ${DIR}/${file} $HOME/${file}
done

# copy .config/* to home directory
for dir in ${DOT_CONFIG_DIR[@]}
do
    \cp -rf ${DIR}/.config/${dir} $HOME/.config/
done
