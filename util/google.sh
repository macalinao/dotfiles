setup_emacs() {
    sudo apt-get remove emacs emacs24
    sudo dpkg -i $HOME/emacs.deb
}
