{
  writeShellApplication,
  jq,
  curl,
  coreutils,
  gawk,
}:

# ccstatus — per-account Claude Code OAuth usage table (see ./ccstatus.sh).
# `sudo ccstatus --all` sweeps every user's home.
writeShellApplication {
  name = "ccstatus";
  runtimeInputs = [
    jq
    curl
    coreutils
    gawk
  ];
  text = builtins.readFile ./ccstatus.sh;
}
