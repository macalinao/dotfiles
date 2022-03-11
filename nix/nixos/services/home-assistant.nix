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
      apple_tv = { };
      automation = { };
      cloud = { };
      counter = { };
      dhcp = { };
      energy = { };
      frontend = { };
      history = { };
      input_boolean = { };
      input_button = { };
      input_datetime = { };
      input_number = { };
      input_select = { };
      input_text = { };
      logbook = { };
      map = { };
      media_source = { };
      mobile_app = { };
      my = { };
      network = { };
      person = { };
      scene = { };
      script = { };
      spotify = { };
      ssdp = { };
      sun = { };
      system_health = { };
      tag = { };
      timer = { };
      usb = { };
      webhook = { };
      yale_smart_alarm = { };
      zeroconf = { };
      zone = { };
      zwave_js = { };
    };

    package = (pkgs.home-assistant.override {
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix
      # extraComponents = [ "zwave_js" "spotify" ];
    }).overrideAttrs (oldAttrs: {
      # Don't run package tests, they take a long time
      doInstallCheck = false;
    });

  };
}
