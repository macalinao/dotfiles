{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all 10.0.0.0/24 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE abacus WITH LOGIN PASSWORD 'abacus' CREATEDB;
      ALTER ROLE abacus WITH SUPERUSER;
      CREATE DATABASE abacus;
      GRANT ALL PRIVILEGES ON DATABASE abacus TO abacus;
    '';
  };
}
