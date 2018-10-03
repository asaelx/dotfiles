# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/asaelx/.oh-my-zsh

# Theme
ZSH_THEME="steeef"

# Plugins
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# Fix Tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
