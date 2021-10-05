self: super: rec {
  pypi2nix = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "pypi2nix";
    rev = "0dbd119465ff2ccbe43cb83431eba792b536a640";
    sha256 = "1zxgy3znw0i6h1lxhmnx001c1pdcyszwqj8f0d0092nmnngdzsrl";
  };

  discord = super.discord.override rec {
    version = "0.0.15";
    src = super.fetchurl {
      url =
        "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-re3pVOnGltluJUdZtTlSeiSrHULw1UjFxDCdGj/Dwl4=";
    };
  };
  python39 = super.python39.override {
    packageOverrides = self: super: {
      beautifulsoup4 = super.beautifulsoup4.overrideAttrs (old: {
        propagatedBuildInputs =
          super.lib.remove super.lxml old.propagatedBuildInputs;
      });
    };
  };
  python39Packages = python39.pkgs;
}
