postgresql() {
    postgres -D /usr/local/var/postgres
}

mongodb() {
    mongod --config /usr/local/etc/mongod.conf
}

