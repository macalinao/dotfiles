ensimeScalaVersion in ThisBuild := "2.12.8"

import scala.sys.process._

PB.runProtoc in Compile := (args => Process("/home/igm/.nix-profile/bin/protoc", args)!)
