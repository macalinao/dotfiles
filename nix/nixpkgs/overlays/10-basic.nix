self: super: rec {
  pypi2nix = super.fetchFromGitHub {
    owner = "nix-community";
    repo = "pypi2nix";
    rev = "0dbd119465ff2ccbe43cb83431eba792b536a640";
    sha256 = "1zxgy3znw0i6h1lxhmnx001c1pdcyszwqj8f0d0092nmnngdzsrl";
  };

  # tests for this are broken on darwin
  python3Packages = super.python3Packages // {
    pycurl = super.python3Packages.pycurl.overrideAttrs
      (oldAttrs: {
        disabledTests = oldAttrs.disabledTests ++ [
          # pycurl.error: (27, '')
          "test_getinfo_raw_certinfo"
          "test_request_with_certinfo"
          "test_request_with_verifypeer"
          "test_request_without_certinfo"
        ];
      });
  };
}
