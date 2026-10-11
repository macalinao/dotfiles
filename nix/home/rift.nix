# Rift window manager config (Darwin only).
#
# The bulk of the config is common and lives in static/rift-common.toml.
# Machine/identity-specific title-routing rules are appended via the
# igm.rift.extraAppRules option, which dotfiles-private sets. Because rift's
# app_rules are a TOML array of tables, extra [[virtual_workspaces.app_rules]]
# blocks concatenated onto the end of the common config simply append to the
# rule list.
#
# Stable, cert-signed binary: Homebrew's rift is an ad-hoc-signed CLI binary,
# and TCC (Accessibility) keys a CLI grant on its resolved real path
# (/opt/homebrew/Cellar/rift/<ver>/bin/rift) plus a cdhash requirement, so
# every `brew upgrade` silently drops the grant. Activation therefore copies
# the brew binary to a fixed, non-symlink path and re-signs it with the
# self-signed `igm-codesign` identity from the login keychain. With a stable
# path and a requirement anchored on a stable certificate, the grant survives
# upgrades. The LaunchAgent (formerly an unmanaged plist written by
# `rift service install`) is managed here and runs that stable copy.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Keep rift's own label so `rift service restart|stop` and `rift-cli
  # service` keep targeting this agent. Home Manager names the plist
  # <Label>.plist, so it replaces the old unmanaged
  # ~/Library/LaunchAgents/git.acsandmann.rift.plist in place (it boots the
  # old job out before installing the new file).
  label = "git.acsandmann.rift";
  signingIdentity = "igm-codesign";
  brewBinary = "/opt/homebrew/opt/rift/bin/rift";
  stableDir = "${config.home.homeDirectory}/.local/libexec/rift";
  stableBinary = "${stableDir}/rift";
  # Byte-for-byte copy of the brew binary that stableBinary was signed from.
  # Signing rewrites the file, so this is what upgrades are detected against.
  unsignedCopy = "${stableDir}/rift.unsigned";

  agentPath = lib.concatStringsSep ":" (
    lib.unique (
      config.home.sessionPath
      ++ [
        "${config.home.homeDirectory}/.nix-profile/bin"
        "${config.home.profileDirectory}/bin"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/usr/local/bin"
        "/usr/bin"
        "/bin"
        "/usr/sbin"
        "/sbin"
        "${config.home.homeDirectory}/.local/bin"
      ]
    )
  );
in
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

  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.file.".config/rift/config.toml".text =
      builtins.readFile ./static/rift-common.toml + config.igm.rift.extraAppRules;

    launchd.agents.rift = {
      enable = true;
      config = {
        Label = label;
        ProgramArguments = [ stableBinary ];
        EnvironmentVariables = {
          PATH = agentPath;
          RUST_LOG = "error,warn,info";
        };
        RunAtLoad = true;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        LimitLoadToSessionType = "Aqua";
        Nice = -20;
        ProcessType = "Interactive";
        StandardOutPath = "/tmp/rift_${config.home.username}.out.log";
        StandardErrorPath = "/tmp/rift_${config.home.username}.err.log";
      };
    };

    # Copy + sign before setupLaunchAgents so a (re)loaded agent finds the
    # binary. Never fails activation: on any problem it warns and leaves the
    # existing copy alone.
    home.activation.installRift = lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "writeBoundary" ] ''
      riftBinaryChanged=0

      riftIsCertSigned() {
        local info
        info="$(/usr/bin/codesign -dvv "$1" 2>&1)" || return 1
        [[ $'\n'"$info"$'\n' == *$'\n'"Authority=${signingIdentity}"$'\n'* ]]
      }

      # Atomically place a copy of $1 at $2 (same-dir temp file + mv).
      riftInstallCopy() {
        local tmp
        tmp="$(mktemp "${stableDir}/.rift.XXXXXX")" || return 1
        if cp "$1" "$tmp" && chmod 755 "$tmp" && mv -f "$tmp" "$2"; then
          return 0
        fi
        rm -f "$tmp"
        return 1
      }

      installRift() {
        local src=${lib.escapeShellArg brewBinary}
        local dst=${lib.escapeShellArg stableBinary}
        local orig=${lib.escapeShellArg unsignedCopy}
        local tmp out

        if [[ ! -f "$src" ]]; then
          warnEcho "rift: $src not found (is the rift formula installed?); leaving $dst as is"
          return 0
        fi

        if [[ -f "$dst" ]] && cmp -s "$src" "$orig" && riftIsCertSigned "$dst"; then
          verboseEcho "rift: $dst is up to date"
          return 0
        fi

        if [[ -v DRY_RUN ]]; then
          echo "Would copy $src to $dst and sign it with '${signingIdentity}'"
          return 0
        fi

        mkdir -p ${lib.escapeShellArg stableDir} || return 1
        tmp="$(mktemp ${lib.escapeShellArg stableDir}/.rift.XXXXXX)" || return 1
        if ! { cp "$src" "$tmp" && chmod 755 "$tmp"; }; then
          rm -f "$tmp"
          return 1
        fi

        if out="$(/usr/bin/codesign --force --sign ${signingIdentity} --identifier ${label} "$tmp" 2>&1)"; then
          if mv -f "$tmp" "$dst" && riftInstallCopy "$src" "$orig"; then
            riftBinaryChanged=1
            echo "rift: installed $dst signed with '${signingIdentity}'"
            return 0
          fi
          rm -f "$tmp"
          return 1
        fi

        rm -f "$tmp"
        warnEcho "rift: codesign with identity '${signingIdentity}' failed (identity missing or login keychain locked?):"
        warnEcho "rift:   $out"
        if [[ -f "$dst" ]]; then
          warnEcho "rift: keeping the existing $dst"
        else
          # Nothing to fall back to: install brew's ad-hoc-signed binary so the
          # agent can still start. The next successful activation re-signs it
          # (it is detected as not cert-signed).
          riftInstallCopy "$src" "$dst" || return 1
          riftBinaryChanged=1
          warnEcho "rift: installed an ad-hoc-signed copy at $dst; its Accessibility grant will not survive re-signing"
        fi
        return 0
      }

      installRift || warnEcho "rift: failed to install ${stableBinary}; leaving the existing copy alone"
    '';

    # Restart a running agent onto the new binary. If setupLaunchAgents just
    # (re)bootstrapped the agent this is a redundant but harmless restart.
    home.activation.restartRift = lib.hm.dag.entryAfter [ "setupLaunchAgents" ] ''
      if [[ "''${riftBinaryChanged:-0}" == 1 ]] && /bin/launchctl print "gui/$UID/${label}" >/dev/null 2>&1; then
        run /bin/launchctl kickstart -k "gui/$UID/${label}" \
          || warnEcho "rift: failed to restart gui/$UID/${label}"
      fi
    '';
  };
}
