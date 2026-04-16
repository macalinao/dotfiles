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
        # localhost (IPv4 + IPv6) and Tailscale CGNAT range
        "127.0.0.1/32,::1/128,100.64.0.0/10"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
