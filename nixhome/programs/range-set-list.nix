{ mkDerivation, base, containers, deepseq, fetchgit, hashable
, stdenv, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "range-set-list";
  version = "0.1.3";
  src = fetchgit {
    url = "https://github.com/phadej/range-set-list";
    sha256 = "0azbd6m651nm662j1ss7nmf6kwdlk66h7mw7ghxnhafd0qfr0xz0";
    rev = "7a477eb9059270fceeef1913cf64002d587b64ac";
    fetchSubmodules = true;
  };
  revision = "1";
  libraryHaskellDepends = [ base containers deepseq hashable ];
  testHaskellDepends = [
    base containers deepseq hashable tasty tasty-quickcheck
  ];
  homepage = "https://github.com/phadej/range-set-list#readme";
  description = "Memory efficient sets with ranges of elements";
  license = stdenv.lib.licenses.mit;
}
