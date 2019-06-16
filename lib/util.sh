postgresql() {
    postgres -D /usr/local/var/postgres
}

mongodb() {
    mongod --config /usr/local/etc/mongod.conf
}

alias dcos-ssh="dcos node ssh --master-proxy --leader --user=centos"
alias dcos-cqlsh="dcos-ssh 'sudo docker run -ti cassandra:3.4 cqlsh node-0.cassandra.mesos'"

alias aws-ecrgetlogin="aws ecr get-login --region=us-east-1 --no-include-email"
alias aws-ecrlogin="aws ecr get-login --region=us-east-1 --no-include-email | bash"
alias dockenv='eval "$(docker-machine env default)"'
alias emacsd='emacs --daemon'
alias emacst='emacsclient -t'
alias gst="git status"
alias gs=gst

alias grt="git root"
alias gco="git checkout"

gac() {
    git add -A $(git root) && git commit -m "$@"
}

alias gd="git diff"

gj() {
    cd `git root`
}

gi() {
    curl -L -s https://www.gitignore.io/api/$@
}

alias glog='git log --oneline --decorate --graph'

# Initialize a new project.
pinit() {
    mkdir -p $HOME/proj/$1 && cd $HOME/proj/$1 && git init && echo "# $1" > README.md && emacsclient -n README.md
}

ghclone() {
    mkdir -p ~/proj/$1 && cd ~/proj/$1 && git clone git@github.com:$1/$2.git && cd $2
}

ghnew() {
    mkdir -p ~/proj/$1/$2 && cd ~/proj/$1/$2 && git init && hub create -p $1/$2
}

ghnewu() {
    mkdir -p ~/proj/macalinao/$1 && cd ~/proj/macalinao/$1 && git init && hub create -p $1
}

ghgo() {
    cd ~/proj/$1/$2
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

# Gets your local IP
imalison_localip() {
    ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}
alias l="exa -lah"

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
alias x=exit
alias c=clear

alias tf=terraform

alias pbstack="pbpaste | jq .stack_trace | unescape.py"

aws_account() {
  aws sts get-caller-identity --output text --query 'Account'
}

aws_list_buckets() {
    aws s3api list-buckets --query 'Buckets[*].Name'
}

aws_mfa_bucket() {
    if [ "$#" -ne 2 ]; then
        echo "Enables MFA delete for an AWS bucket."
        echo "Usage: aws_mfa_bucket <bucket-name> <mfa-passcode>"
        return 1
    fi
    aws s3api put-bucket-versioning \
        --bucket $1 \
        --versioning-configuration '{"MFADelete":"Enabled","Status":"Enabled"}' \
        --mfa "arn:aws:iam::$(aws_account):mfa/ian $2"

}

alias k8sec="pbpaste | base64 -w | pbcopy"
