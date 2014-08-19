# Temp directory
TEMP_DIR= "~/tmp-deb"
mkdir $TEMP_DIR
cd $TEMP_DIR

# Mandatory stuff
sudo apt-get -y install unzip
sudo apt-get -y install curl zsh vim tmux synapse
# Git is already installed -- no need to worry.

read -p "Install desktop utilities? (y/n): " RESP
if [ "$RESP" = "y" ]; then
    sudo apt-get -y install iceweasel
fi

read -p "Install development tools? (y/n): " RESP
if [ "$RESP" = "y" ]; then
    sudo apt-get -y install openjdk-7-jdk openjdk-7-jre 
    sudo apt-get -y install python python-pip
    pip install --user git+git://github.com/Lokaltog/powerline

    # GVM - gradle/groovy
    curl -s get.gvmtool.net | bash
    
    # Node
    sudo n latest
    npm config set prefix ~/npm

    # Ruby
    curl -L https://get.rvm.io | bash -s stable --ruby
fi

chsh -s $(which zsh)

rm -rf $TEMP_DIR
