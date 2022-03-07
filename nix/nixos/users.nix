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
        openssh.authorizedKeys.keyFiles =
          [ ./authorized-keys/ian-mbp.pub ./authorized-keys/ian-mbp-2022.pub ];
      };
      nas = {
        name = "nas";
        uid = 1002;
        home = "/home/nas";
        shell = pkgs.zsh;
        isNormalUser = true;
        openssh.authorizedKeys.keyFiles =
          [ ./authorized-keys/ian-mbp.pub ./authorized-keys/ian-mbp-2022.pub ];
      };
    };
  };
}
