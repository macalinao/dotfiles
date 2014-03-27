# Temp directory
TEMP_DIR= "~/tmp-deb"
mkdir $TEMP_DIR
cd $TEMP_DIR

# Mandatory stuff
apt-get -y install curl zsh vim tmux synapse
apt-get -y install xfce4 xfce4-goodies gtk2-engines-murrine
# Git is already installed -- no need to worry.

read -p "Install social utilities? (y/n): " RESP
if [ "$RESP" = "y" ]; then
    apt-get -y install pidgin xchat iceweasel
fi

read -p "Install development tools? (y/n): " RESP
if [ "$RESP" = "y" ]; then
    apt-get -y install openjdk-7-jdk openjdk-7-jre 
    apt-get -y install python

    # GVM - gradle/groovy
    curl -s get.gvmtool.net | sh
    
    # Node
    git clone https://github.com/visionmedia/n.git
    cd n
    make install
    n latest
    cd ..
fi

chsh -s $(which zsh)

rm -rf $TEMP_DIR
