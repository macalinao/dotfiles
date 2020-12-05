self: super: {
  factorio = super.factorio.override {
    username = "albireox";
    token = super.lib.removeSuffix "\n" (builtins.readFile
      "${super.config.home.homeDirectory}/private_secrets/secrets/factorio.txt");
  };

  nodejs = super.nodejs-15_x;

  yarn = super.yarn.override { nodejs = super.nodejs-15_x; };

  proto3-suite = super.callPackage ../programs/proto3-suite.nix { };

  rofi-systemd = super.callPackage ../programs/rofi-systemd.nix { };
}
