{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "git-worktree-runner";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "coderabbitai";
    repo = "git-worktree-runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ltM/QM5sGYJdUbmZQHx7TZa829zG3s0Eh9ZHmZYNWiE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0755 bin/git-gtr bin/gtr -t $out/share/git-worktree-runner/bin
    cp -r lib adapters scripts templates completions $out/share/git-worktree-runner/

    # git-gtr resolves its GTR_DIR via BASH_SOURCE; keeping the wrappers in
    # $out/share/.../bin means relative lib/ lookups keep working.
    makeWrapper $out/share/git-worktree-runner/bin/git-gtr $out/bin/git-gtr
    makeWrapper $out/share/git-worktree-runner/bin/gtr     $out/bin/gtr

    runHook postInstall
  '';

  meta = {
    description = "Bash-based Git worktree manager with editor and AI tool integration";
    homepage = "https://github.com/coderabbitai/git-worktree-runner";
    license = lib.licenses.mit;
    mainProgram = "gtr";
    platforms = lib.platforms.unix;
  };
})
