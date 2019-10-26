# Fix vim lang
export LC_ALL=en_US.UTF-8

# PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/asaelx/.oh-my-zsh

# Theme
ZSH_THEME="af-magic"

# Plugins
plugins=(zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

source $HOME/.bash_aliases
