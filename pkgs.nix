nixpkgs: nixpkgsForGraal21: system:
let
  makeOverlays =
    java: javaVersion:
    let
      pkgsForGraal21 = import nixpkgsForGraal21 {
        inherit system;
      };

      chosenJre = if javaVersion == 21 then pkgsForGraal21.${java} else null;

      graalAliasOverlay = final: prev: {
        graalvm-ce = final.graalvmPackages.graalvm-ce;
      };

      javaOverlay = final: _: {
        jdk = if chosenJre != null then chosenJre else final.${java};
        jre = if chosenJre != null then chosenJre else final.${java};
      };

      # Every tool here asserts on jre.version, so anything the devshell's own
      # jdk is too old to run gets the newest jvm instead. The project still
      # compiles against final.jdk; only the tool's own runtime moves.
      jreFloorOverlay =
        final: prev:
        let
          atLeast = floor: if javaVersion >= floor then final.jre else final.graalvm-ce;
        in
        {
          ammonite = prev.ammonite.override { jre = atLeast 11; };
          bloop = prev.bloop.override { jre = atLeast 17; };
          metals = prev.metals.override { jre = atLeast 17; };
          mill = prev.mill.override { jre = atLeast 17; };
          sbt = prev.sbt.override { jre = atLeast 17; };
          scala-cli = prev.scala-cli.override { jre = atLeast 17; };

          # coursier, giter8 and scalafmt have no floor: they run on the
          # devshell's own jdk, which is the point of them being here.
        };

      nodejsOverlay = final: _: {
        nodejs = final.nodejs_24;
      };
    in
    [
      graalAliasOverlay
      javaOverlay
      jreFloorOverlay
      nodejsOverlay
    ];

  makePackages =
    java: javaVersion:
    let
      overlays = makeOverlays java javaVersion;
    in
    import nixpkgs {
      inherit system overlays;
    };

  default = pkgs25;
  pkgs25 = makePackages "graalvm-ce" 25;
  pkgs21 = makePackages "graalvm-ce" 21;
  pkgs17 = makePackages "temurin-bin-17" 17;
  pkgs11 = makePackages "temurin-bin-11" 11;
  pkgs8 = makePackages "openjdk8" 8;
in
{
  inherit
    default
    pkgs25
    pkgs21
    pkgs17
    pkgs11
    pkgs8
    ;
}
