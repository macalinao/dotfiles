alias dcos-ssh="dcos node ssh --master-proxy --leader --user=centos"
alias dcos-cqlsh="dcos-ssh 'sudo docker run -ti cassandra:3.4 cqlsh node-0.cassandra.mesos'"
