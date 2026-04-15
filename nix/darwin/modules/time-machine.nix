{ ... }:
{
  # Automatic Time Machine backups. Destination volume must be selected
  # manually in System Settings; macOS has no API to set it declaratively.
  # Build-artifact exclusions (target/, node_modules/, etc.) are managed
  # by asimeow — see nix/home/modules/asimeow.nix.
  system.defaults.CustomUserPreferences = {
    "com.apple.TimeMachine" = {
      AutoBackup = 1;
      RequiresACPower = 1;
    };
  };
}
