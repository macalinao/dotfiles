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

  # tests for this are broken on darwin
  python3Packages = super.python3Packages // {
    pycurl = super.python3Packages.pycurl.overrideAttrs
      (oldAttrs: {
        disabledTests = oldAttrs.disabledTests ++ [
          # pycurl.error: (27, '')
          "test_getinfo_raw_certinfo"
          "test_request_with_certinfo"
          "test_request_with_verifypeer"
          "test_request_without_certinfo"
        ];
      });
  };
}
