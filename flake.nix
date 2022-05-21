{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    igm.url = "path:./nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { igm, flake-utils, nixpkgs, ... }:
    (flake-utils.lib.eachSystem [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ]
      (system:
        let
          nixpkgs-config-public = (import ./nix/nixpkgs/config.nix { });
          pkgs = import nixpkgs {
            inherit system;
            inherit (nixpkgs-config-public) config overlays;
          };
        in
        {
          # packages = {
          #   rust-shell = pkgs.mkShell {
          #     name = "rust-shell";
          #     nativeBuildInputs = with pkgs; [
          #       libiconv
          #       rustc
          #       cargo
          #     ];
          #     buildInputs = with pkgs; [
          #       rustc
          #       cargo
          #     ];
          #   };
          # };
          devShell = with pkgs;
            mkShell {
              nativeBuildInputs =
                [ coreutils-full nixpkgs-fmt wally-cli shfmt yarn nodejs ];
            };
        })) // {
      inherit (igm) nixosConfigurations;
    };
}
