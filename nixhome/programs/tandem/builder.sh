source $stdenv/setup
PATH=$dpkg/bin:$PATH

dpkg -x $src unpacked/

mkdir -p $out/
cp -R unpacked/* $out/

ldd unpacked/opt/Tandem/tandem
