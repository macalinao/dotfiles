with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "devops";
    buildInputs = [
        aws-iam-authenticator
        awscli
        jx
        kops
        kubernetes
        kubernetes-helm
        skaffold
        sops
        terraform
        terraform-providers.aws
    ];
  };
}
