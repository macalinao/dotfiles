self: super: rec {
  pypi2nix = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "pypi2nix";
    rev = "0dbd119465ff2ccbe43cb83431eba792b536a640";
    sha256 = "1zxgy3znw0i6h1lxhmnx001c1pdcyszwqj8f0d0092nmnngdzsrl";
  };

  kitty = super.kitty.overrideAttrs (existing: {
    patches = [
      # From https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/terminal-emulators/kitty/default.nix
      # Fix clone-in-kitty not working on bash >= 5.2
      # TODO: Removed on kitty release > 0.26.5
      (super.fetchpatch {
        url = "https://github.com/kovidgoyal/kitty/commit/51bba9110e9920afbefeb981e43d0c1728051b5e.patch";
        sha256 = "sha256-1aSU4aU6j1/om0LsceGfhH1Hdzp+pPaNeWAi7U6VcP4=";
      })
    ] ++ existing.patches;
  });

  # kitty = with super; darwin.apple_sdk_11_0.callPackage ./packages/kitty.nix {
  #   harfbuzz = harfbuzz.override { withCoreText = stdenv.isDarwin; };
  #   inherit (darwin.apple_sdk_11_0) Libsystem;
  #   inherit (darwin.apple_sdk_11_0.frameworks)
  #     Cocoa
  #     Kernel
  #     UniformTypeIdentifiers
  #     UserNotifications
  #     ;
  # };
}
