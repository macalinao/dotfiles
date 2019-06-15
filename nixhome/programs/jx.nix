{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  name = "jx";
  version = "2.0.180";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "0n7a05j10d5gn0423jwr16ixlhz0dv1d5bbzcf5k4h916d77ycbl";
  };

  modSha256 = "0ykz9qrlp3z71yrbs20krk6b1v7bdbj5i40w5s3rm5c1a7r6aa30";

  subPackages = [ "cmd/jx" ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/jenkins-x/jx/pkg/version.Version=${version}
    -X github.com/jenkins-x/jx/pkg/version.Revision=${version}
  '';

  meta = with lib; {
    description = "JX is a command line tool for installing and using Jenkins X.";
    homepage = https://jenkins-x.io;
    longDescription = ''
      Jenkins X provides automated CI+CD for Kubernetes with Preview
      Environments on Pull Requests using Jenkins, Knative Build, Prow,
      Skaffold and Helm.
    '';
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
