{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    haskell.hie.enable = true;
    userSettings = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSave" = true;
      "[toml]" = {
        "editor.defaultFormatter" = "bodil.prettier-toml";
      };
      "[nix]" = {
        "editor.tabsize" = 2;
      };
      "[go]" = {
        "editor.defaultFormatter" = "ms-vscode.go";
      };
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust";
      };
      "[sql]" = {
        "editor.defaultFormatter" = "adpyke.vscode-sql-formatter";
      };
      "[shellscript]" = {
        "editor.defaultFormatter" = "foxundermoon.shell-format";
      };
      "[scala]" = {
        "editor.defaultFormatter" = "scalameta.metals";
      };
      "[terraform]" = {
        "editor.defaultFormatter" = "mauve.terraform";
      };
      "vim.useSystemClipboard" = true;
      "gitlens.advanced.messages"."suppressShowKeyBindingsNotice" = true  ;
      "window.zoomLevel" = -1;
      "files.associations" = {
        "*.mdx"  = "markdown";
        "*.toml" = "toml";
      };
      "typescript.updateImportsOnFileMove.enabled" = "never";
      "gitlens.views.fileHistory.enabled" = true;
      "gitlens.views.lineHistory.enabled" = true;
      "workbench.colorTheme" = "Material Theme High Contrast";
      "metals.javaHome" = pkgs.openjdk8;
      "showMusicMetrics" = true;
      "eslint.validate" = [
        "javascript"
        "javascriptreact"
        {
          "autoFix" = true;
          "language" = "typescript";
        }
        {
          "autoFix" = true;
          "language" = "typescriptreact";
        }
      ];
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = true;
      };
    };
    extensions = with pkgs.vscode-extensions; pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Get these hashes by putting in the wrong hash.
      # `home-manager switch` will tell you what the correct hash is.
      {
        name = "nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "0.7.0";
        sha256 = "0bgs6dy429m5yn10dd8m321slf5mqgsbr86ip61kvjwh67q9glcr";
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
        version = "2.9.0";
        sha256 = "1blz6fh60bqny4fskln1a3n0xggfn9w9vdrabh5h73ighqi2w51z";
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
      {
        name = "go";
        publisher = "ms-vscode";
        version = "0.10.1";
        sha256 = "1gqpqivfg046s9sydjndm8pnfc4q4m9412dl56fc0f2rb7xfgsbn";
      }
      {
        name = "terraform";
        publisher = "mauve";
        version = "1.3.11";
        sha256 = "0di7psqcn7gmdl604cxra2xnc8rc6izandqz44qrgjl3j41vp8jr";
      }
      {
        name = "vscode-apollo";
        publisher = "apollographql";
        version = "1.7.1";
        sha256 = "18r5d0f7hkz2s1hm7lanfymrvjarpb1sfplhi93dc5qz93q10l6a";
      }
      {
        name = "language-haskell";
        publisher = "justusadam";
        version = "2.6.0";
        sha256 = "1891pg4x5qkh151pylvn93c4plqw6vgasa4g40jbma5xzq8pygr4";
      }
      {
        name = "vscode-hie-server";
        publisher = "alanz";
        version = "0.0.27";
        sha256 = "1mz0h5zd295i73hbji9ivla8hx02i4yhqcv6l4r23w3f07ql3i8h";
      }
      {
        name = "shell-format";
        publisher = "foxundermoon";
        version = "6.0.1";
        sha256 = "1zkvrlhmw8id65km9cfpgv8p3w1ym4g4mr7cmb32fn3yk937gpmy";
      }
      {
        name = "vscode-github";
        publisher = "knisterpeter";
        version = "0.30.2";
        sha256 = "0axq6a8lgf17kwmsw3fj5g4n0wgwr7x6qfxshaqbl6ac6p1pnd9v";
      }
      {
        name = "vscode-pull-request-github";
        publisher = "github";
        version = "0.8.0";
        sha256 = "0gk9jb8i894jx7a0wjx3w220kh55gyczrfi01b3dcdnwi8gvh80n";
      }
      {
        name = "vscode-spotify";
        publisher = "shyykoserhiy";
        version = "3.1.0";
        sha256 = "1zf09678g16zyqccplhzhv8ciq7wmrz25i2ghw7q0cggm4713g12";
      }
      {
        name = "indent-rainbow";
        publisher = "oderwat";
        version = "7.4.0";
        sha256 = "1xnsdwrcx24vlbpd2igjaqlk3ck5d6jzcfmxaisrgk7sac1aa81p";
      }
      {
        name = "rainbow-brackets";
        publisher = "2gua";
        version = "0.0.6";
        sha256 = "1m5c7jjxphawh7dmbzmrwf60dz4swn8c31svbzb5nhaazqbnyl2d";
      }
      {
        name = "vscode-import-cost";
        publisher = "wix";
        version = "2.12.0";
        sha256 = "1g6k8fxfa49ky8v3l5n6l7p6gnjf9sdd56crcj33p08gb8pyy86l";
      }
      {
        name = "rust";
        publisher = "rust-lang";
        version = "0.6.3";
        sha256 = "1r5q1iclr64wmgglsr3na3sv0fha5di8xyccv7xwcv5jf8w5rz5y";
      }
      {
        name = "vetur";
        publisher = "octref";
        version = "0.22.6";
        sha256 = "0k9akddgbbrjsdl08w4a2nbsj0gi7bki7yjap2c4c1ic9v0lxihi";
      }
      {
        name = "vscode-eslint";
        publisher = "dbaeumer";
        version = "1.9.1";
        sha256 = "0q3vnqmik1228zsy7favzsr3xpaci3z1zh38m79cpy5rac5bcr62";
      }
      {
        name = "better-toml";
        publisher = "bungcip";
        version = "0.3.2";
        sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
      }
      {
        name = "prettier-toml";
        publisher = "bodil";
        version = "0.1.0";
        sha256 = "04zyxf4lwkphci6j7svzirha86dad86m3kk7r29skaph2dkw12vg";
      }
      {
        name = "sqltools";
        publisher = "mtxr";
        version = "0.21.6";
        sha256 = "0iyxmj29p6ymnvjwraxxh883gm3asn25azbg1v6dqam700bjlgr2";
      }
      {
        name = "vscode-sql-formatter";
        publisher = "adpyke";
        version = "1.4.4";
        sha256 = "06q78hnq76mdkhsfpym2w23wg9wcpikpfgz07mxk1vnm9h3jm2l3";
      }
    ];
  };
}
