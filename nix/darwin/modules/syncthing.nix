# Syncthing user agent. Installed from nixpkgs (no nix-darwin
# `services.syncthing` upstream — modeled after `./lemonade.nix`).
#
# Pairs with devbox to keep the Obsidian vault at
# `~/proj/macalinao/vault` in real-time sync. Config (devices, shared
# folders, GUI password) is managed via the web UI at
# http://127.0.0.1:8384 on first launch — devbox's nix module is the
# source of truth for its side, and the Mac side is small enough that
# declarative config isn't worth the complexity here.
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.syncthing ];

  launchd.user.agents.syncthing = {
    serviceConfig = {
      Label = "com.syncthing.syncthing";
      ProgramArguments = [
        "${pkgs.syncthing}/bin/syncthing"
        "serve"
        # launchd already restarts the agent — let syncthing exit cleanly
        # rather than self-restart, so KeepAlive is in charge.
        "--no-restart"
        # Don't open a browser tab on first start.
        "--no-browser"
        # Localhost-only GUI. Reach via SSH port-forward from another
        # machine if needed.
        "--gui-address=127.0.0.1:8384"
        # Quieter timestamps — launchd already timestamps its log.
        "--logflags=0"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      # syncthing writes its own logs under
      # ~/Library/Application Support/Syncthing — these capture stderr
      # before the daemon takes over, useful for diagnosing crash loops.
      StandardOutPath = "/tmp/syncthing.out.log";
      StandardErrorPath = "/tmp/syncthing.err.log";
    };
  };
}
