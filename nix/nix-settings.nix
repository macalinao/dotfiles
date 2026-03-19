{
  nix.settings = {
    sandbox = false;
    trusted-users = [
      "root"
      "igm"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://igm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "igm.cachix.org-1:JzRjOzUEP3tfmQv9hy7MP7LqaA5CEg418KKVMyJFd10="
    ];
  };
}
