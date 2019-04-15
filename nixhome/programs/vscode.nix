{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    userSettings = {
      "vim.useSystemClipboard" = true;
      "gitlens.advanced.messages"."suppressShowKeyBindingsNotice" = true  ;
      "gitlens.historyExplorer.enabled" = true;
      "window.zoomLevel" = 0;
      "files.associations"."*.mdx"  = "markdown";
      "typescript.updateImportsOnFileMove.enabled" = "never";
      "gitlens.views.fileHistory.enabled" = true;
      "gitlens.views.lineHistory.enabled" = true;
      "workbench.colorTheme" = "Default Light+";
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
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
      {
        name = "prettier-vscode";
        publisher = "esbenp";
        version = "1.8.1";
        sha256 = "0qcm2784n9qc4p77my1kwqrswpji7bp895ay17yzs5g84cj010ln";
      }
      {
        name = "vscode-typescript-tslint-plugin";
        publisher = "ms-vscode";
        version = "0.4.1";
        sha256 = "0fsf9ycc7b09adifipylx1gfg51nmzlqb8n2v3l3g52lx9lxk3is";
      }
      {
        name = "graphql-for-vscode";
        publisher = "kumar-harsh";
        version = "1.3.0";
        sha256 = "0ff0f6g0gq4ckvs9qpkcskz1af9v82xxakzs4rljw85vw8yfpq73";
      }
      {
        name = "vscode-styled-components";
        publisher = "jpoissonnier";
        version = "0.0.25";
        sha256 = "12qgx56g79snkf9r7sgmx3lv0gnzp7avf3a5910i0xq9shfr67n0";
      }
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.3.1";
        sha256 = "1sfpsp8m24k9mmaq1dscpy25mn9f7a9qgsr7sz8flv9b0blb0jcy";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.2.0";
        sha256 = "0z2knfgn1g5rvanssnz6ym8zqyzzk5naaqsggrv77k6jzd5lpw49";
      }
    ];
  };
}
