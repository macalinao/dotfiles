alias gst="git status"
alias gs=gst

alias grt="git root"

gac() {
    git add -A $(git root) && git commit -am $1
}

alias gd="git diff"

gj() {
    cd `git root`
}

gi() {
    curl -L -s https://www.gitignore.io/api/$@
}
