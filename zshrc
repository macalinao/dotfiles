# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
ZSH_THEME="agnoster"

alias gac="git add -A . && git commit -am"
plugins=(git gitignore gradle bundler rails)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH
export EDITOR=vim

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
export ANDROID_HOME="/usr/local/android-sdk-linux/"

# NPM
export PATH=$HOME/npm/bin:$PATH

# Android
export PATH=$HOME/Library/Android/sdk/tools:$PATH
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

# Resty
source ~/dotfiles/etc/resty

# Transfer.sh
source ~/dotfiles/etc/transfer

motivate | yosay
alias x=exit

# Azure
if type compdef &>/dev/null; then
  _azure_complette() {
    compadd -- `azure --compzsh --compgen "${CURRENT}" "${words[CURRENT-1]}" "${BUFFER}"`
  }
  compdef _azure_complette azure
elif type complete &>/dev/null; then
  _azure_complette() {
    COMPREPLY=( $(compgen -W '$(azure --compbash --compgen "${COMP_CWORD}" "${COMP_WORDS[COMP_CWORD-1]}" "${COMP_LINE}")' -- "${COMP_WORDS[COMP_CWORD]}") )
  }
  complete -F _azure_complette azure
fi

alias mars="java -jar ~/dotfiles/opt/Mars4_5.jar"

# Ctags
alias ctags="`brew --prefix`/bin/ctags"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_40.jdk/Contents/Home

alias c=clear
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias yolo="git push origin master -f"
alias swag="git push origin staging -f"
alias kukuku="git push heroku master -f"
alias gs=gst

export GOPATH=~/gocode
export PATH=~/gocode/bin:$PATH

md2pdf() {
  pandoc $1 -o `basename $1 .md`.pdf
}
