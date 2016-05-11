md2pdf() {
    pandoc $1 -o `basename $1 .md`.pdf
}
