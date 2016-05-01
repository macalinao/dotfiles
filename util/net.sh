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

# Gets your local IP
imalison_localip() {
    ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}
