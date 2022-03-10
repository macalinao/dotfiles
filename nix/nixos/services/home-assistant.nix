{ pkgs, ... }: {
  services.home-assistant = {
    enable = true;
    # Good starting config, that will get you through the configuration
    # flow, that has a hard dependency on a few components.
    #
    # Components might not actually have YAML configuration, but
    # mentioning them in the configuration will get their dependencies
    # loaded.
    config = {
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
      # https://www.home-assistant.io/integrations/esphome/
      esphome = { };
      # https://www.home-assistant.io/integrations/met/
      met = { };
    };

    package = (pkgs.home-assistant.override {
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix
      extraComponents = [ "default_config" "met" "zwave_js" "spotify" ];
    }).overrideAttrs (oldAttrs: {
      # Don't run package tests, they take a long time
      doInstallCheck = false;
    });

  };
}
