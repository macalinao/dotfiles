{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.9.1";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-aarch64-apple-darwin.tar.xz";
      hash = "sha256-ZfT+9DdLT9e1GtQSlu2J3fHFQYnUEzijSHNYpElfaWs=";
    };
    x86_64-darwin = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-apple-darwin.tar.xz";
      hash = "sha256-48oKJytD8iUzKugMaTUM+aJKB9Hg1C+3jF6kltriBeU=";
    };
    aarch64-linux = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-aarch64-unknown-linux-gnu.tar.xz";
      hash = "sha256-FZ1zfQqIoX9IXq28Ti5AN+omqwwJGYsAtVbleXpSgN8=";
    };
    x86_64-linux = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-unknown-linux-gnu.tar.xz";
      hash = "sha256-+LEDaEK9WIgPBfR2krT0nAq7Oq01Lxjb9O6V3z7C+7s=";
    };
  };

  platform = stdenv.hostPlatform.system;
  source = sources.${platform} or (throw "Unsupported platform: ${platform}");
in

stdenv.mkDerivation {
  pname = "linear-cli";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 */linear $out/bin/linear
    runHook postInstall
  '';

  meta = {
    description = "CLI for Linear issue tracking";
    homepage = "https://github.com/schpet/linear-cli";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = builtins.attrNames sources;
    mainProgram = "linear";
  };
}
