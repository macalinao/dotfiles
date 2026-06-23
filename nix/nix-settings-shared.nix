# Nix settings safe for both system-level (NixOS/nix-darwin) and user-level (Home Manager) config.
{ pkgs, lib, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://igm.cachix.org"
      "https://claude-code.cachix.org"
      "https://codex-cli.cachix.org"
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
    ]
    # @NixOS/cuda-maintainers Hydra cache — Linux only. Lets CUDA hosts
    # substitute torch/cudnn/ctranslate2 prebuilt instead of compiling
    # locally. Gated on isLinux so it applies to NixOS systems and
    # Home-Manager-on-Linux but not darwin (no CUDA there, just a wasted
    # narinfo query). Moved off cuda-maintainers.cachix.org Nov 2025;
    # new content lands here.
    ++ lib.optional pkgs.stdenv.hostPlatform.isLinux "https://cache.nixos-cuda.org";
    extra-trusted-public-keys = [
      "igm.cachix.org-1:JzRjOzUEP3tfmQv9hy7MP7LqaA5CEg418KKVMyJFd10="
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isLinux "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=";
  };
}
