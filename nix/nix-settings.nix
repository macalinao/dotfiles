# System-level nix settings (NixOS/nix-darwin only).
# For settings shared with Home Manager, see nix-settings-shared.nix.
{
  imports = [ ./nix-settings-shared.nix ];

  nix.settings = {
    sandbox = false;
    trusted-users = [
      "root"
      "igm"
    ];
  };
}
