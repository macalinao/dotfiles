{ pkgs }:
mkShell {
  nativeBuildInputs = [
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

    heroku
    google-cloud-sdk
  ];
}
