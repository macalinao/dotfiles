# Mandatory stuff
sudo apt-get -y install unzip
sudo apt-get -y install curl zsh vim tmux
# Git is already installed -- no need to worry.

read -p "Install desktop utilities? (y/n): " RESP
if [ "$RESP" = "y" ]; then
    sudo apt-get -y install iceweasel
fi

read -p "Install development tools? (y/n): " RESP
if [ "$RESP" = "y" ]; then
    sudo apt-get -y install openjdk-7-jdk openjdk-7-jre 

    # Python
    sudo apt-get -y install python python-pip
    pip install --user git+git://github.com/Lokaltog/powerline

    # GVM - gradle/groovy
    curl -s get.gvmtool.net | bash
    
    # Node
    curl https://raw.githubusercontent.com/creationix/nvm/v0.23.2/install.sh | bash
    source ~/.nvm/nvm.sh
    nvm install iojs-v1.0.4
    npm config set prefix ~/npm
    npm install -g yo mocha jshint derulo js-beautify ionic cordova gulp grunt-cli bower lice-js mantra

    # Ruby
    curl -L https://get.rvm.io | bash -s stable --ruby
    gem install hub
fi

chsh -s $(which zsh)
