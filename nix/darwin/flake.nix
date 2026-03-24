{
  description = "Darwin-specific inputs";

  inputs = {
    darwin.url = "github:lnl7/nix-darwin/master";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-casks.url = "github:atahanyorganci/nix-casks/archive";
  };

  outputs = _: { };
}
