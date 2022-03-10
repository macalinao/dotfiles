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
      spotify = { };
      zwave_js = { };
    };
  };
}
