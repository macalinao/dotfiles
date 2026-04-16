{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.lemonade ];

  launchd.user.agents.lemonade = {
    serviceConfig = {
      Label = "com.lemonade.server";
      ProgramArguments = [
        "${pkgs.lemonade}/bin/lemonade"
        "server"
        "--allow"
        "127.0.0.1"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
