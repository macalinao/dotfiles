alias l="ls -lah"

psgrep() {
    if [ "$#" -ne 1 ]; then
        echo "Finds matching processes and displays info."
        echo "Usage: psgrep <string>"
    else
        ps aux | grep $1 | grep -v grep
    fi
}
