export PATH=$PATH:/opt/homebrew/bin


# keychain
keychain --nogui --quiet ~/.ssh/id_rsa
source ~/.keychain/$HOST-sh

# direnv
eval "$(direnv hook zsh)"
