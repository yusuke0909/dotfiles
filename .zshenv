export PATH=$PATH:/opt/homebrew/bin


# keychain
keychain --nogui --quiet ~/.ssh/id_rsa
source ~/.keychain/$HOST-sh


# direnv
eval "$(direnv hook zsh)"


# AWSume alias to source the AWSume script
alias awsume="source \$(pyenv which awsume)"

#Auto-Complete function for AWSume
fpath=(~/.awsume/zsh-autocomplete/ $fpath)
