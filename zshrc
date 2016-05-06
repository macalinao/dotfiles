ZSH=$HOME/dotfiles/oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git gitignore gradle bundler rails)

source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH
export EDITOR=emacsclient

# Fix tab completion http://stackoverflow.com/questions/564648/zsh-tab-completion-for-cd
zstyle ':completion:*' special-dirs true

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# NPM
export PATH=$HOME/npm/bin:$PATH

alias x=exit

alias c=clear

export GOPATH=$HOME/gocode
export PATH=$GOPATH/bin:$PATH

md2pdf() {
  pandoc $1 -o `basename $1 .md`.pdf
}

export HISTFILESIZE=10000000
export HISTSIZE=10000000

alias vi=vim
alias e="emacsclient -n"

export GO15VENDOREXPERIMENT=1

sev() {
  cd $GOPATH/src/code.uber.internal/everything/$1
}

DOTFILES=$HOME/dotfiles

source $DOTFILES/util/git.sh
source $DOTFILES/util/net.sh
source $DOTFILES/util/os.sh
source $DOTFILES/util/transfer.sh