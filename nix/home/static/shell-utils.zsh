ssh-keygen-quick() {
  if [ ! $1 ]; then
    echo "Usage: ssh-keygen-quick <username>"
    return 1
  fi
  ssh-keygen -N "" -C "" -f $HOME/.ssh/id_rsa_$1
}

ghclone() {
  PROJ_WITH_ORG=$1
  if [ ! $(echo "$1" | grep "/") ]; then
    PROJ_WITH_ORG=macalinao/$1
  fi
  DIR=$HOME/proj/$PROJ_WITH_ORG
  git clone git@github.com:$PROJ_WITH_ORG.git $DIR && cd $DIR
}

ghnew() {
  PROJ_WITH_ORG=$1
  if [ ! $(echo "$1" | grep "/") ]; then
    PROJ_WITH_ORG=macalinao/$1
  fi
  DIR=$HOME/proj/$PROJ_WITH_ORG
  mkdir -p $DIR && cd $DIR/.. && gh repo create --private $PROJ_WITH_ORG --clone && cd $DIR
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

sfxl() {
  play -v 10.0 $DOTFILES/sfx/$1.ogg
}

docker-stop-all() {
  docker container stop $(docker container ls -aq)
}

# Disable mouse tracking after SSH exits to prevent escape sequence
# garbage (e.g. 35;70;18M35;71) from appearing in the terminal when
# the remote session (tmux, vim, etc.) disconnects without cleanup.
ssh() {
  command ssh "$@"
  printf '\e[?1000l\e[?1002l\e[?1003l\e[?1005l\e[?1006l\e[?1015l\e[?1016l'
}
