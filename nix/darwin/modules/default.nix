{ inputs }:

let
  inherit (inputs)
    self
    home-manager
    nix-index-database
    nix-casks
    ;
in
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../system.nix
    ../../nix-settings.nix
    ./time-machine.nix
    ./lemonade.nix
    ./syncthing.nix
    nix-index-database.darwinModules.nix-index
    home-manager.darwinModules.home-manager
  ];

  igm.mode = "personal";

  nixpkgs = import ../../nixpkgs/config.nix {
    isDarwin = true;
    additionalOverlays = [
      self.overlays.default
    ];
  };

  environment.systemPackages =
    let
      casks = nix-casks.packages.${pkgs.stdenv.hostPlatform.system};
      # nixpkgs ships darktable as a bare GTK binary on darwin (no .app bundle),
      # so it never appears in Spotlight/Launchpad. Hand-roll a minimal macOS
      # .app around the cached build: an Info.plist, an .icns, and a launcher
      # symlink to the real binary. This composes over pkgs.darktable (no
      # overrideAttrs), so the prebuilt binary is reused — no source rebuild.
      #
      # Note: we do NOT use desktopToDarwinBundle — its write-darwin-bundle
      # helper segfaults on the currently pinned nixpkgs. Rolling the bundle by
      # hand avoids that tool entirely and is independent of nixpkgs revisions.
      darktable-app = pkgs.stdenvNoCC.mkDerivation {
        pname = "darktable-app";
        inherit (pkgs.darktable) version;
        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        nativeBuildInputs = [ pkgs.libicns ]; # png2icns
        installPhase = ''
          mkdir -p $out/bin
          ln -s ${pkgs.darktable}/bin/darktable $out/bin/darktable

          app=$out/Applications/darktable.app
          mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
          ln -s ${pkgs.darktable}/bin/darktable "$app/Contents/MacOS/darktable"

          icons=${pkgs.darktable}/share/icons/hicolor
          png2icns "$app/Contents/Resources/darktable.icns" \
            "$icons/16x16/apps/darktable.png" \
            "$icons/32x32/apps/darktable.png" \
            "$icons/48x48/apps/darktable.png" \
            "$icons/256x256/apps/darktable.png"

          cat > "$app/Contents/Info.plist" <<EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>CFBundleExecutable</key><string>darktable</string>
            <key>CFBundleIdentifier</key><string>org.darktable.darktable</string>
            <key>CFBundleName</key><string>darktable</string>
            <key>CFBundleDisplayName</key><string>darktable</string>
            <key>CFBundleIconFile</key><string>darktable</string>
            <key>CFBundleVersion</key><string>${pkgs.darktable.version}</string>
            <key>CFBundleShortVersionString</key><string>${pkgs.darktable.version}</string>
            <key>CFBundlePackageType</key><string>APPL</string>
            <key>NSHighResolutionCapable</key><true/>
          </dict>
          </plist>
          EOF
        '';
      };
    in
    (with pkgs; [
      vim
      anki-bin
      darktable-app
      ghostty-bin
      google-chrome
      keka
      keymapp
      obsidian
      signal-desktop
      spotify
      tableplus
      telegram-desktop
      zed-editor
      zoom-us
    ])
    # macOS apps via nix-casks (in systemPackages for Spotlight indexing)
    ++ (with casks; [
      beeper
      bitwarden
      firefox
      notion
      notunes
      transmission
      vlc
    ]);

  home-manager.users.igm =
    { config, ... }:
    {
      imports = [ self.homeModules.default ];
      igm.dotfilesPath = "${config.home.homeDirectory}/proj/macalinao/dotfiles";
    };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };

  system.primaryUser = "igm";
  system.defaults = {
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
    dock = {
      mru-spaces = false;
      autohide = true;
      tilesize = 32;
      expose-animation-duration = 0.0;
    };
  };

  system.stateVersion = 5;
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  ids.gids.nixbld = 30000;

  homebrew = import ../homebrew.nix { inherit config lib pkgs; };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    variables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };
  };

  # Disabled while trialing Rift (acsandmann/rift). Re-enable to switch back.
  services.yabai = {
    enable = false;
    enableScriptingAddition = false;
    config = {
      layout = "bsp";
    };
    extraConfig = ''
      yabai -m rule --add app="^Simulator" manage=off
      yabai -m rule --add app="^qemu-system-aarch64" manage=off
    '';
  };

  programs.gnupg.agent.enable = true;

  users.users.igm = {
    name = "igm";
    home = "/Users/igm";
    shell = pkgs.zsh;
  };
}
