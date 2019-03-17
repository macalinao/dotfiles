{ pkgs, ... }:

{
  # Sorry RMS, MS is too alluring
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    htop
    fortune
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 24 * 60 * 60;
    enableSshSupport = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "vim.useSystemClipboard" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Get these hashes by putting in the wrong hash.
      # `home-manager switch` will tell you what the correct hash is.
      {
        name = "vscode-docker";
        publisher = "peterjausovec";
        version = "0.6.0";
        sha256 = "07gavimf3037vbd2a6753aw7i9966q55f0712pgzgimbw6c4cyf7";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "9.1.0";
        sha256 = "0a6iqnqmig0s4d107vzwygybndd9hq99kk6mykc88c8qgwf0zdrr";
      }
      {
        name = "vscode-proto3";
        publisher = "zxh404";
        version = "0.2.2";
        sha256 = "1gasx3ay31dy663fcnhpvbys5p7xjvv30skpsqajyi9x2j04akaq";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "0.16.14";
        sha256 = "0b8d3sj3754l3bwcb5cdn2z4z0nv6vj2vvaiyhrjhrc978zw7mby";
      }
      {
        name = "vsc-material-theme";
        publisher = "equinusocio";
        version = "2.6.3";
        sha256 = "1ghqp0yfcpcnjcwgvxw7aix9fj5q8kr0i97lmzlw2jqslmyvxg5x";
      }
    ];
  };
}
