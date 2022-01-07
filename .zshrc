# PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.scripts/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="ys"

# Plugins
plugins=(zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

source $HOME/.aliases

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
