self: super: {
  factorio = super.factorio.override {
    username = "albireox";
    token = super.lib.removeSuffix "\n"
      (builtins.readFile "/home/igm/private_secrets/secrets/factorio.txt");
  };

  proto3-suite = super.callPackage ../programs/proto3-suite.nix { };

  rofi-systemd = super.callPackage ../programs/rofi-systemd.nix { };

  discord = super.discord.override rec {
    version = "0.0.13";
    src = super.fetchurl {
      url =
        "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0d5z6cbj9dg3hjw84pyg75f8dwdvi2mqxb9ic8dfqzk064ssiv7y";
    };
  };

  pypi2nix = super.fetchgit {
    url = "https://github.com/nix-community/pypi2nix";
    rev = "e56cbbce0812359e80ced3d860e1f232323b2976";
    sha256 = "1vhdippb0daszp3a0m3zb9qcb25m6yib4rpggaiimg7yxwwwzyh4";
  };
}
