gac() {
    git add -A $(git root) && git commit -m "$@"
}

gi() {
    curl -L -s https://www.gitignore.io/api/$@
}

ghclone() {
    DIR=$HOME/proj/$1
    mkdir -p $DIR && cd $DIR/.. && git clone git@github.com:$1.git && cd $DIR
}

ghnew() {
    DIR=$HOME/proj/$1
    mkdir -p $DIR && cd $DIR && git init && hub create -p $1
}

ghnewu() {
    ghnew macalinao/$1
}

ghgo() {
    DIR=$HOME/proj/$1
    cd $DIR
}

lsport() {
    if [ "$#" -ne 1 ]; then
        echo "Gets information about processes running on the given port."
        echo "Usage: lsport <port>"
    else
        lsof -wni tcp:$1
    fi
}

pidport() {
    if [ "$#" -ne 1 ]; then
        echo "Gets the pid of the process running on the given port."
        echo "Usage: pidport <port>"
    else
        lsof -twni tcp:$1
    fi
}

killport() {
    if [ "$#" -ne 1 ]; then
        echo "Kills whatever process is running on a port with a SIGTERM."
        echo "Usage: killport <port>"
    else
        pidport $1 | xargs kill -9
    fi
}

tunnelport() {
    if [ "$#" -ne 2 ]; then
        echo "Tunnels a local port to the corresponding remote port on a machine."
        echo "Usage: tunnelport <port> <host>"
    else
        ssh -fN -L $1":localhost:"$1 $2
    fi
}

psgrep() {
    if [ "$#" -ne 1 ]; then
        echo "Finds matching processes and displays info."
        echo "Usage: psgrep <string>"
    else
        ps aux | grep $1 | grep -v grep
    fi
}
md2pdf() {
    pandoc $1 -o `basename $1 .md`.pdf
}
    
sfxl() {
  play -v 10.0 $DOTFILES/sfx/$1.ogg
}

source $HOME/private_secrets/lib/helpers.sh

docker-stop-all() {
  docker container stop $(docker container ls -aq)
}

stop-conflicting-services() {
  sudo systemctl stop postgresql
  sudo systemctl stop openvpn-us-silicon-valley
}

bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
