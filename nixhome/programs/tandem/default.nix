let nixpkgs = import <nixpkgs> {};
    stdenv = nixpkgs.stdenv;
in stdenv.mkDerivation {
  name = "tandem";
  src = nixpkgs.fetchurl {
    url = "https://downloads.tandem.chat/linux/deb/x64";
    sha256 = "0flm83k0jg74d73g7vry11zcb7hjsy4s2yibjx8zmib65zgqym68";
  };
  nativeBuildInputs = with nixpkgs; [
    dpkg
    autoPatchelfHook
  ];
  buildInputs = with nixpkgs; with xorg; [
    glib
    fontconfig
    freetype
    pango
    cairo
    libX11
    libXi
    atk
    nss
    nspr
    libXcursor
    libXext
    libXfixes
    libXrender
    libXScrnSaver
    libXcomposite
    libxcb
    alsaLib
    libXdamage
    libXtst
    libXrandr
    expat
    cups
    dbus
    gtk3
    gdk-pixbuf
    gcc-unwrapped
    at-spi2-atk
    at-spi2-core
    kerberos
    libdrm
    mesa
    libxkbcommon
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src unpacked/
    cp -R unpacked/* $out/
    ldd unpacked/opt/Tandem/tandem
  '';
}
