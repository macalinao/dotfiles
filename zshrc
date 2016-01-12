ZSH=$HOME/dotfiles/oh-my-zsh

ZSH_THEME="robbyrussell"

alias gac="git add -A . && git commit -am"
plugins=(git gitignore gradle bundler rails)

source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:$HOME/dotfiles/bin:/usr/local/bin:$PATH
export EDITOR=vim

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

motivate | yosay
alias x=exit

# Ctags
alias ctags="`brew --prefix`/bin/ctags"

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home

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

DYLD_LIBRARY_PATH=/opt/oracle/instantclient_11_2
export HISTFILESIZE=10000000
export HISTSIZE=10000000

alias vi=vim
