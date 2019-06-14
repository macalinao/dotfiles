{ mkDerivation, aeson, aeson-pretty, attoparsec, base
, base64-bytestring, binary, bytestring, cereal, containers
, contravariant, deepseq, doctest, fetchgit, filepath, foldl
, hashable, haskell-src, insert-ordered-containers, lens, mtl
, neat-interpolation, optparse-applicative, optparse-generic
, parsec, parsers, pretty, pretty-show, proto3-wire, QuickCheck
, quickcheck-instances, range-set-list, safe, semigroups, stdenv
, swagger2, system-filepath, tasty, tasty-hunit, tasty-quickcheck
, text, transformers, turtle, vector
}:
mkDerivation {
  pname = "proto3-suite";
  version = "0.3.0.1";
  src = fetchgit {
    url = "https://github.com/awakesecurity/proto3-suite";
    sha256 = "0qzcjymzma3m6qyzl84h6lh3qhsz94vhcgqbz2w32y4f5h0xznb5";
    rev = "2dd8a7af3b37899d7a96734a485f07e86809fd48";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-pretty attoparsec base base64-bytestring binary
    bytestring cereal containers contravariant deepseq filepath foldl
    hashable haskell-src insert-ordered-containers lens mtl
    neat-interpolation parsec parsers pretty pretty-show proto3-wire
    QuickCheck quickcheck-instances safe semigroups swagger2
    system-filepath text transformers turtle vector
  ];
  executableHaskellDepends = [
    base containers mtl optparse-applicative optparse-generic
    proto3-wire range-set-list system-filepath text turtle
  ];
  testHaskellDepends = [
    aeson attoparsec base base64-bytestring bytestring cereal
    containers deepseq doctest mtl pretty-show proto3-wire QuickCheck
    semigroups swagger2 tasty tasty-hunit tasty-quickcheck text
    transformers turtle vector
  ];
  description = "A low level library for writing out data in the Protocol Buffers wire format";
  license = stdenv.lib.licenses.asl20;
}
