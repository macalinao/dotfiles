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
