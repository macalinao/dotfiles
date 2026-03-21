{
  description = "Darwin-specific inputs";

  inputs = {
    darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager";
    nix-index-database.url = "github:nix-community/nix-index-database";
    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
    nix-casks.url = "github:atahanyorganci/nix-casks/archive";
  };

  outputs = _: { };
}
