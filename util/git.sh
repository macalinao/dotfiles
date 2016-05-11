alias gst="git status"
alias gs=gst

alias grt="git root"

gac() {
    git add -A $(git root) && git commit -am
}

alias gd="git diff"

gj() {
    cd `git root`
}
