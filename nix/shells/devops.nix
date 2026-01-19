{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    aws-iam-authenticator
    awscli
    # jx
    kops
    # kubernetes
    kubernetes-helm
    skaffold
    sops
    terraform
    terraform-providers.hashicorp_aws

    heroku
    google-cloud-sdk
  ];
}
