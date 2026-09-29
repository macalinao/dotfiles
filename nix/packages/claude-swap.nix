{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

# claude-swap — multi-account switcher for Claude Code (`cswap`).
python3Packages.buildPythonApplication rec {
  pname = "claude-swap";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "realiti4";
    repo = "claude-swap";
    tag = "v${version}";
    hash = "sha256-ypE/fxgMr+SSF/8blI2YVqcr9coW3YcGzC/NiogyadQ=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    textual
    truststore
  ];

  pythonImportsCheck = [ "claude_swap" ];

  meta = {
    description = "Multi-account switcher for Claude Code";
    homepage = "https://github.com/realiti4/claude-swap";
    license = lib.licenses.mit;
    mainProgram = "cswap";
  };
}
