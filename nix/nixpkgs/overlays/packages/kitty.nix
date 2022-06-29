{ pkgs }:

with pkgs;
pkgs.kitty.overrideAttrs (prev: rec {
  version = "0.25.2";
  name = "kitty-${version}";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "sha256-o/vVz1lPfsgkzbYjYhIrScCAROmVdiPsNwjW/m5n7Us=";
  };

  patches = [
    # Needed on darwin

    # Gets `test_ssh_shell_integration` to pass for `zsh` when `compinit` complains about
    # permissions.
    # ./zsh-compinit.patch
    (fetchpatch {
      name = "zsh-compinit.patch";
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/b22c2113df12d785e784a131baf944d4f9cf4784/pkgs/applications/terminal-emulators/kitty/zsh-compinit.patch";
      sha256 = "sha256-55Sov4WKRQSRxb3P0YyHsgjFDxQzYGku4rILQuKmdFc=";
    })

    # Skip `test_ssh_bootstrap_with_different_launchers` when launcher is `zsh` since it causes:
    # OSError: master_fd is in error condition
    (fetchpatch {
      name = "disable-test_ssh_bootstrap_with_different_launchers.patch";
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/b22c2113df12d785e784a131baf944d4f9cf4784/pkgs/applications/terminal-emulators/kitty/disable-test_ssh_bootstrap_with_different_launchers.patch";
      sha256 = "sha256-nT8R+0Xad16x7XzVSwLcYuOwZX9P2JMi5MmaF5PDKj0=";
    })
  ];

  meta = prev.meta // {
    broken = false;
  };
})
