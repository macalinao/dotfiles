ZSH=$HOME/dotfiles/oh-my-zsh

ZSH_THEME="robbyrussell"

alias gac="git add -A . && git commit -am"
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

# Transfer.sh
source ~/dotfiles/etc/transfer

alias x=exit

# Ctags
alias ctags="`brew --prefix`/bin/ctags"

alias c=clear
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias yolo="git push origin master -f"
alias swag="git push origin staging -f"
alias kukuku="git push heroku master -f"
alias gs=gst

export GOPATH=$HOME/gocode
export PATH=$GOPATH/bin:$PATH

md2pdf() {
  pandoc $1 -o `basename $1 .md`.pdf
}

imalison_localip() {
  ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}

export HISTFILESIZE=10000000
export HISTSIZE=10000000

alias vi=vim
alias e="emacsclient -n"

alias grt="git root"

export GO15VENDOREXPERIMENT=1

gj() {
  cd `git root`
}

sev() { cd $GOPATH/src/code.uber.internal/everything/$1 }
