# Rift window manager config (Darwin only).
#
# The bulk of the config is common and lives in static/rift-common.toml.
# Machine/identity-specific title-routing rules are appended via the
# igm.rift.extraAppRules option, which dotfiles-private sets. Because rift's
# app_rules are a TOML array of tables, extra [[virtual_workspaces.app_rules]]
# blocks concatenated onto the end of the common config simply append to the
# rule list.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.igm.rift.extraAppRules = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = ''
      Extra rift app_rules, as TOML `[[virtual_workspaces.app_rules]]`
      blocks. Concatenated onto the end of the common rift config to append
      to the app_rules list. Used by dotfiles-private for title-based
      workspace routing that references private context.
    '';
  };

  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".config/rift/config.toml".text =
      builtins.readFile ./static/rift-common.toml + config.igm.rift.extraAppRules;
  };
}
