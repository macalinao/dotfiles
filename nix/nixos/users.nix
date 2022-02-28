{ pkgs, ... }:

{
  users = {
    extraUsers = {
      igm = {
        name = "igm";
        uid = 1001;
        home = "/home/igm";
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "transmission" ];
        openssh.authorizedKeys.keyFiles = [ ./authorized-keys/ian-mbp.pub ];
      };
    };
  };
}
