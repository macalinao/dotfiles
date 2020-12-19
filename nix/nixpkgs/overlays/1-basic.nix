self: super: rec {
  dotfiles-private = import ../../dotfiles-private { lib = super.lib; };

  factorio = super.factorio.override {
    username = "albireox";
    token = dotfiles-private.factorio-token;
  };

  discord = super.discord.override rec {
    version = "0.0.13";
    src = super.fetchurl {
      url =
        "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0d5z6cbj9dg3hjw84pyg75f8dwdvi2mqxb9ic8dfqzk064ssiv7y";
    };
  };

  pypi2nix = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "pypi2nix";
    rev = "0dbd119465ff2ccbe43cb83431eba792b536a640";
    sha256 = "1zxgy3znw0i6h1lxhmnx001c1pdcyszwqj8f0d0092nmnngdzsrl";
  };

  nix-pre-commit-hooks = import (super.fetchFromGitHub {
    owner = "cachix";
    repo = "pre-commit-hooks.nix";
    rev = "d16e007e6bd263ba5899a9a425d76a78906570cd";
    sha256 = "1c0lv3yzq1kkqm4j37wl5hlawlsrj1413vkr1mdm661klad2sa0d";
  });
}
