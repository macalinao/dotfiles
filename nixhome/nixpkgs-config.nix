{ config, pkgs, lib, ... }:

{
  allowUnfree = true;
  packageOverrides = pkgs: {
    factorio = pkgs.factorio.override {
      username = "albireox";
      token = lib.removeSuffix "\n" (
        builtins.readFile "${config.home.homeDirectory}/private_secrets/secrets/factorio.txt"
      );
    };

    yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-14_x; };

    proto3-suite = pkgs.callPackage ./programs/proto3-suite.nix { };

    rofi-systemd = pkgs.callPackage ./programs/rofi-systemd.nix { };
  };
}
