{ fetchFromGitHub }:
let 
  proto3Src = fetchFromGitHub {
    owner  = "awakesecurity";
    repo   = "proto3-suite";
    rev    = "973c317b91405a11438e3a21706024bfa3d754df";
    sha256 = "091db048hgcq5idvf5gaiqb6hzbs7g1dz6xjqdx61dw2yxgdm957";
  };
  proto3-suite = import "${proto3Src}/release.nix";
  result = proto3-suite { };
in result.proto3-suite
