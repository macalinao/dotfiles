{
  description = "NixOS-specific inputs";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
  };

  outputs = _: { };
}
