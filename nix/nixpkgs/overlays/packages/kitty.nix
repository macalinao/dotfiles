{ pkgs }:

with pkgs;
pkgs.kitty.overrideAttrs (prev: rec {
  version = "0.25.1";
  name = "kitty-${version}";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "sha256-wL631cbA6ffXZomi6iDHk7XerRlpIL6T2qlEiQvFSJY=";
  };

  patches = [
    # Fix to ensure that files in tar files used by SSH kitten have write permissions.
    (fetchpatch {
      name = "fix-tarball-file-permissions.patch";
      url = "https://github.com/kovidgoyal/kitty/commit/8540ca399053e8d42df27283bb5dd4af562ed29b.patch";
      sha256 = "sha256-y5w+ritkR+ZEfNSRDQW9r3BU2qt98UNK7vdEX/X+mKU=";
    })

    # Needed on darwin

    # Gets `test_ssh_shell_integration` to pass for `zsh` when `compinit` complains about
    # permissions.
    # ./zsh-compinit.patch
    (fetchpatch {
      name = "zsh-compinit.patch";
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/b22c2113df12d785e784a131baf944d4f9cf4784/pkgs/applications/terminal-emulators/kitty/zsh-compinit.patch";
      sha256 = "sha256-55Sov4WKRQSRxb3P0YyHsgjFDxQzYGku4rILQuKmdFc=";
    })

    # Skip login shell detection when login shell is set to nologin
    (fetchpatch {
      name = "skip-login-shell-detection-for-nologin.patch";
      url = "https://github.com/kovidgoyal/kitty/commit/27906ea853ce7862bcb83e324ef80f6337b5d846.patch";
      sha256 = "sha256-Zg6uWkiWvb45i4xcp9k6jy0R2IQMT4PXr7BenzZ/md8=";
    })
    # Skip `test_ssh_bootstrap_with_different_launchers` when launcher is `zsh` since it causes:
    # OSError: master_fd is in error condition
    # ./disable-test_ssh_bootstrap_with_different_launchers.patch
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
