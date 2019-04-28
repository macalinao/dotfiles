{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  name = "jx";
  version = "2.0.61";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "15ql69m01681kwppvfd00zyzdnfgpz4akn6w86f4yk4gngpqm3b8";
  };

  patches = [
    # https://github.com/jenkins-x/jx/pull/3321
    # ./fix-location-of-thrift.patch
  ];

  modSha256 = "06wwkil45znyjx3w4v00ybq7rsr0rs6i473hpiprx0cgj6msbg51";

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
