alias gst="git status"
alias gs=gst

alias grt="git root"
alias gco="git checkout"

gac() {
    git add -A $(git root) && git commit -m "$@"
}

alias gd="git diff"

gj() {
    cd `git root`
}

gi() {
    curl -L -s https://www.gitignore.io/api/$@
}

alias glog='git log --oneline --decorate --graph'

# Initialize a new project.
pinit() {
    mkdir -p $HOME/proj/$1 && cd $HOME/proj/$1 && git init && echo "# $1" > README.md && emacsclient -n README.md
}

ghclone() {
    mkdir -p ~/proj/$1 && cd ~/proj/$1 && hub clone -p $1/$2 && cd $2
}

ghnew() {
    mkdir -p ~/proj/$1/$2 && cd ~/proj/$1/$2 && git init && hub create -p $1/$2
}

ghgo() {
    cd ~/proj/$1/$2
}
