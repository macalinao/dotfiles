{ fetchFromGitHub }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "league-of-legends";
  src = fetchFromGitHub {
    owner  = "Nefelim4ag";
    repo   = "League-Of-Legends";
    rev    = "91ee85bfa2eefaa9bf6f53529f3cde75ae4fb9a9";
    sha256 = "1kcf0m7fdk7vxqsjkics69s8svy8jcqdvim4vzxdmc5qfv0vbjqb";
  };

  buildInputs = [
    bash
    wine-staging
    winetricks
    wget
  ];

  dontBuild = true;

  installPhase = ''
    # Make the output directory
    mkdir -p $out/bin

    bash leagueoflegends install

    # Copy the script there and make it executable
    cp leagueoflegends $out/bin/
    chmod +x $out/bin/leagueoflegends
  '';
}
