# keychain
keychain --nogui --quiet ~/.ssh/id_rsa
source ~/.keychain/$HOST-sh

# anyenv
if [ -d ${HOME}/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - zsh)"
  for D in `ls $HOME/.anyenv/envs`
  do
      export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# direnv
eval "$(direnv hook zsh)"
