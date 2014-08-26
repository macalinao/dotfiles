# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
ZSH_THEME="agnoster"

alias gac="git add -A . && git commit -am"
plugins=(git gitignore gradle)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH
export EDITOR=vim
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

# Fix tab completion http://stackoverflow.com/questions/564648/zsh-tab-completion-for-cd
zstyle ':completion:*' special-dirs true

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "$HOME/.gvm/bin/gvm-init.sh" ]] && source "$HOME/.gvm/bin/gvm-init.sh"

# Android
export PATH="/usr/local/android-sdk-linux/platform-tools:/usr/local/android-sdk-linux/tools:$PATH"

# NPM
export PATH=$HOME/npm/bin:$PATH

# Resty
source ~/dotfiles/etc/resty

mantra
alias x=exit
